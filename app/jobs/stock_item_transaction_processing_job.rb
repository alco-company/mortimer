class StockItemTransactionProcessingJob < ApplicationJob
  queue_as :transactions

  def perform(*args)
    begin     
      keys = REDIS.keys "stock_item_transactions:*"
      while keys.any?
        key = keys.shift
        parms = JSON.parse( REDIS.get(key) ) rescue nil
        if parms 
          StockItemTransactionService.new.create_pos_transaction( parms )
        end
        REDIS.del key 
      end
    rescue => exception
      say exception
    ensure      
      REDIS.del "stock_item_transaction_processing_job"
    end
  end
end
