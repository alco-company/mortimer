module StockItemTransactionsHelper

  def set_pos_transaction_color(transaction) 
    return "bg-green-200" if transaction.state=='RECEIVE'
    return "bg-yellow-200"
  end

  def link_to_stock_item resource 
    return link_to resource.stock_item.name, stock_item_url(resource.stock_item) unless resource.stock_item.name.blank? 
    link_to 'item', stock_item_url(resource.stock_item)
  end

  
end
