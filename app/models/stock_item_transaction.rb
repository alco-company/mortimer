
#
# StockItemTransaction have only a few states
# RECEIVE - adding units to the current stock
# SHIP - subtracting units from the current stock
# INVENTORY - sum the current units 
# SCRAP - a special kind of subtracting units
#
class StockItemTransaction  < AbstractResource
  include Eventable

  belongs_to :stocked_product
  belongs_to :stock_location
  belongs_to :stock_item

  def self.default_scope
    StockItemTransaction.all.joins(:event)
  end
  
  
  # 
  # methods supporting broadcasting 
  #
  def broadcast_create
    broadcast_prepend_later_to model_name.plural, 
    target: "#{self.class.to_s.underscore}_list", 
    partial: self, 
    locals: { resource: self, user: Current.user }
    broadcast_prepend_later_to "pos_stock_item_transactions", 
    target: "pos_stock_item_transaction_list", 
    partial: "pos/stock_item_transactions/stock_item_transaction", 
    locals: { resource: self, user: Current.user }
  end
  
  private 

end
