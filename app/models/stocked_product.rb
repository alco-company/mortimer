# t.bigint "product_id", null: false
# t.bigint "stock_id", null: false
# t.bigint "stock_location_id", null: false
# t.string "stock_unit"
#
class StockedProduct < AbstractResource
  include Assetable

  belongs_to :product
  belongs_to :stock
  belongs_to :stock_location

  has_many :stock_item_transactions, dependent: :destroy
  has_many :stock_items, dependent: :destroy

  def self.default_scope
    StockedProduct.all.joins(:asset)
  end

  def combo_values_for_stock_id
    return [{id: nil, name: ''}] if stock.nil?
    [{id: stock.id, name: stock.name}]
  end

  def nbr_pallets
    q = stock_item_transactions.pluck :state
    p = 0
    q.each{ |s| case s when 'RECEIVE'; p+=1 when 'SHIP'; p-=1 end } if q.any?
    p
  end

  def quantity
    st = stock_item_transactions.pluck( :state, :quantity).compact
    qt = 0
    st.each{ |s,q| case s when 'RECEIVE'; qt+=(q||0) when 'SHIP'; qt-=(q||0) end } if st.any?
    qt
  end
  


  #
  # Task - if updated without the event being 'called'
  #
  def broadcast_update
    if self.asset.deleted_at.nil? 
      broadcast_replace_later_to 'stocked_product', 
        partial: 'stocked_products/stocked_product', 
        target: self, 
        locals: {resource: self, user: Current.user }
    else 
      broadcast_remove_to 'stocked_product', target: self
    end
  end

  def broadcast_destroy
    raise "StockedProduct should not be hard-deleteable!"
    # after_destroy_commit { broadcast_remove_to self, partial: self, locals: {resource: self} }
  end
  #
  #

end
