module Pos
  class StocksController < AbstractResourcesController

    skip_before_action :authenticate_user!, only: [:heartbeat, :show, :pallets]
    skip_before_action :breadcrumbs
    skip_before_action :set_paper_trail_whodunnit
    
    skip_before_action :set_resource
    skip_before_action :set_ancestry
    skip_before_action :set_resources

    def set_resource_class 
      @resource_class= Stock
    end

    def say msg 
      return unless Rails.env.development?
      Rails.logger.info '--------------------------------------------------------'
      Rails.logger.info msg
      Rails.logger.info '--------------------------------------------------------'
    end

    def pallets
      stock = Stock.unscoped.find( _id)
      asset= Asset.unscoped.where( assetable: stock).first
      if asset && stock 
        redirect_to root_path and return unless stock.access_token == params[:api_key]
        Current.account = asset.account
        @resources = stock.stock_item_transactions.joins(:event).where( "events.state='RECEIVE'").pluck(:name).uniq
      else
        head 401
      end
    end

    #
    # the barcode reader in warehouse etc
    # https://expertlabels.co.uk/news/what-retail-suppliers-need-to-know-about-barcodes/
    #
    def show 
      @resource= Asset.unscoped.where( assetable: Stock.unscoped.find( _id)).first
      Current.account = @resource.account
      redirect_to root_path and return unless token_approved
      render layout: "stock_pos"
    end

    #
    # heartbeat updates the stock with a timestamp
    def heartbeat
      @resource= Asset.unscoped.where( assetable: Stock.unscoped.find( _id)).first
      Current.account = @resource.account
      redirect_to root_path and return unless token_approved
      Stock.unscoped.find(_id).update last_heart_beat_at: DateTime.current
    end


    # GET /accounts/:id/stocks/:id/inventory
    def inventory
      # @stocked_products = @stock.stocked_products.not_marked_as_destroyed.eager_load :stock_transactions
      # unless params[:items].nil? # they'd be puttin'
      #   params[:items].each do |item|
      #     stocked_product = StockedProduct.find_by barcode: item["barcode"], stock_id: @stock.id
      #     if stocked_product
      #       ts = (Time.zone.at(item["ts"].to_i / 1000 ).localtime) rescue DateTime.current
      #       stocked_product.quantity_in_stock = item["quantity_in_stock"]
      #       stocked_product.quantity_in_stock_at = ts
      #       stocked_product.save
      #     end
      #   end
      #   head :ok
      # else
      #   @account = Account.find(params[:account_id])
      #   @stock_transaction = StockTransaction.new account: @account
      # end
    end

    def re_stock
      # @account = Account.find(params[:account_id])
      # if params[:restock] && @stock.use_last_ordered_quantity
      #   params[:restock].each do |barcode,value|
      #     sp = StockedProduct.find_by(barcode: barcode).update last_ordered_quantity: value rescue nil
      #   end
      # else
      #   @stock_transaction = StockTransaction.new account: @account
      # end
    end
    
    private 

      # Never trust parameters from the scary internet, only allow the white list through.
      def resource_params
        # params[:asset][:assetable_attributes].delete(:access_token)
        params.require(:asset).permit(:assetable_type, :name, :account_id, assetable_attributes: [ :id, :last_heart_beat_at ] )
      end

      #
      # implement on every controller where search makes sense
      # geet's called from resource_control.rb 
      #
      def find_resources_queried options
        Stock.search Stock.all, params[:q]
      end

    
      def token_approved
        @resource.assetable.access_token == params[:api_key]
      end

  end
end