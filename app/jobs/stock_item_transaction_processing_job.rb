class StockItemTransactionProcessingJob < ApplicationJob
  queue_as :transactions

  retry_on RuntimeError, queue: :transactions, attempts: 2
  
  #
  # stock_item_transactions are quickly stuffed onto Redis
  # then this job is expected to clean up and create bonafide
  # stock_item_transaction record
  #
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
