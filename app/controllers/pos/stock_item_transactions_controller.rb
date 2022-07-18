

# assert -> product
# t.string "barcode" -> supplier_barcode
# t.string "sku"

# asset -> stocked_product
# t.bigint "product_id", null: false
# t.bigint "stock_id", null: false
# t.bigint "stock_location_id"
# stock_unit

# asset -> stock_item
# t.bigint "account_id", null: false
# t.bigint "stock_location_id", null: false
# t.bigint "stocked_product_id", null: false







# event -> stock_item_transaction
#   state 'in', 'out', 'count'
#   stock_location_id (priv)
#   stocked_product_id (ean14)
#   stock_item (batchnr, expire_at)
#   pallet_barcode (sscs)
#   quantity (nbrcont)
#   unit 
#   stock_id (from device)
#   device_id

# t.bigint "consumer_id" -> consumer_transactions.consumer_id

module Pos 
  class StockItemTransactionsController < EventsController

    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user! #, only: [:heartbeat, :show]
    skip_before_action :breadcrumbs
    skip_before_action :set_paper_trail_whodunnit

    skip_before_action :set_resource
    skip_before_action :set_ancestry
    skip_before_action :set_resources

    def set_resource_class 
      @resource_class= StockItemTransaction
    end

    # Parameters: {"stock_item_transaction"=>{"barcode"=>"0012345678901234567810445566 1522040402412301234567893725 91100100", "left"=>"", "sscs"=>"123456789012345678", "batchnbr"=>"445566", "sell"=>"220404", "ean14"=>"41230123456789", "nbrcont"=>"25", "location"=>"100100", "direction"=>"RECEIVE", "unit"=>"pallet"}, "api_key"=>"[FILTERED]", "stock_id"=>"3"}

    # stock_item_transactions are created in various use cases
    # - ordinary/full RECEIVE, SHIP, INVENTORY, SCRAP scan sequence
    # - sscs/short SHIP, INVENTORY, SCRAP scan sequence
    #
    #
    # Second 'thing' is that StockItemTransactions may happen so quickly after each other that
    # a traditional MVC pipeline is not applicable - thus they are 'created'
    # using a modified Message Broker model like this:
    #
    # 1. store the transaction 'data' in Redis
    # 2. return a '200' response as-if
    # 3. process the events in the order they arrived
    # 4. rewrite the '200' responses if necessary
    #
    def create 
      if token_approved && inject_transaction_for_processing
        head 200
      else
        head 422
      end
    end

    def destroy
      # render head: 401 and return unless token_approved
      unless StockItemTransaction.delete_pos_transaction
        head 422
      else
        render turbo_stream: turbo_stream.remove( resource ), status: 303
      end
    end

    private 

      # Never trust parameters from the scary internet, only allow the white list through.
      def resource_params
        params.permit! #( :barcode, :sscs, :sell, :nbrcont, :ean14 )
      end

      #
      # implement on every controller where search makes sense
      # geet's called from resource_control.rb 
      #
      def find_resources_queried options
        StockItemTransaction.search StockItemTransaction.all, params[:q]
      end
    
      def token_approved
        @stock = Stock.unscoped.find params["stock_id"]
        @stock.access_token == params["api_key"]
      rescue
        false
      end

      def inject_transaction_for_processing
        #
        # TODO - make sure two accounts do not mix their transactions !!
        # 
        st_id=REDIS.incr('stock_item_transactions_id') 
        REDIS.set( ("stock_item_transactions:%d" % st_id), JSON.generate(resource_params.to_unsafe_h) ) 
        # is the backgroundjob running?
        unless REDIS.get('stock_item_transaction_processing_job')
          REDIS.set "stock_item_transaction_processing_job", true
          StockItemTransactionProcessingJob.perform_later
        end
        #
        # reset every 1 mio transactions - should be safe
        REDIS.set('stock_item_transactions_id',1) if REDIS.incr('stock_item_transactions_id') > 1_000_000
        true
      rescue
        false
      end


      #
      # this is the StockItemTransactionJob - 
      # use it when debugging in development env
      #
      def perform
        begin     
          keys = REDIS.keys "stock_item_transactions:*"
          looping = keys.size
          while keys && (looping>0)
            key = keys.shift
            parms = JSON.parse( REDIS.get(key) ) rescue nil
            if parms && (StockItemTransactionService.new.create_pos_transaction( parms ) rescue false)
              REDIS.del key 
            else
              looping -= 1
              keys.unshift(key) 
            end
          end
        rescue => exception
          say exception
        ensure      
          REDIS.del "stock_item_transaction_processing_job"
        end
      end
    


      
  end
end