module StockItemTransactionsHelper

  def set_pos_transaction_color(transaction) 
    return "bg-green-200" if transaction.state=='RECEIVE'
    return "bg-yellow-200"
  end

  
end
