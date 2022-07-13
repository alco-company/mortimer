class StockItemTransactionProcessingJob < ApplicationJob
  queue_as :transactions

  def perform(*args)
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
