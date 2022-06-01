# t.bigint "stocked_product_id", null: false
# t.bigint "stock_location_id", null: false
# t.string "batch_number"
# t.datetime "expire_at", precision: 6

class StockItem < AbstractResource
  include Assetable

  belongs_to :stocked_product
  belongs_to :stock_location
  has_many :stock_transactions

  def self.default_scope
    StockItem.all.joins(:asset)
  end

  # add quantity to existing stock_item
  # provide s(tock), s(tocked_)p(roduct), s(tock_)l(ocation), parm
  #
  def self.add_quantity( s, sp, sl, parm)
    begin      
      si = self.find_by( stocked_product_id: sp.id, stock_location: sl.id, batch_number: parm["batchnbr"])
      if si 
        si.update_attribute :quantity, (si.quantity + parm["nbrcont"].to_i)
      else
        si = self.create_for_stock_transaction( s, sp, sl, parm)
      end
      si
    rescue => exception
      raise ActiveRecord::Rollback
      nil
    end
  end

  def self.subtract_quantity( s, st, parm)
    sp = st.stocked_product
    sl = st.stock_location
    si = self.find_by( stocked_product_id: sp.id, stock_location: sl.id, batch_number: parm["batchnbr"])
    if si 
      si.update_attribute :quantity, (si.quantity - st.quantity)
    else
      si = self.create_for_stock_transaction( s, sp, sl, parm)
      si.update_attribute :quantity, 0
    end
    si
  end

  def self.create_for_stock_transaction s, sp, sl, parm 
    acc = s.account
    Asset.create( 
      account_id: acc.id, 
      name: parm["batchnbr"], 
      assetable: StockItem.create( 
        stocked_product_id: sp.id, 
        stock_location_id: sl.id, 
        batch_number: parm["batchnbr"], 
        quantity: parm["nbrcont"],
        unit: parm["unit"],
        expire_at: StockItem.parse_yymmdd( parm["expr"] || parm["sell"])
      )
    ).assetable
  end

  def nbr_pallets
    q = stock_transactions.pluck :state
    p = 0
    q.each{ |s| case s when 'RECEIVE'; p+=1 when 'SHIP'; p-=1 end } if q.any?
    p
  end


  # 
  # methods supporting broadcasting 
  #
  def broadcast_create
    broadcast_prepend_later_to model_name.plural, target: "#{self.class.to_s.underscore}_list", partial: self, locals: { resource: self }
    broadcast_prepend_later_to "stocked_products", target: "stocked_product_list", partial: "stocked_products/stocked_product", locals: { resource: self.stocked_product }
  end
  
  def broadcast_update 
    if self.asset.deleted_at.nil? 
      broadcast_replace_later_to model_name.plural, partial: self, locals: { resource: self }
      broadcast_replace_later_to "stocked_products", partial: "stocked_products/stocked_product", locals: { resource: self.stocked_product }
    else 
      broadcast_remove_to model_name.plural, target: self
      broadcast_replace_later_to "stocked_products", partial: "stocked_products/stocked_product", locals: { resource: self.stocked_product }
    end
  end
  #
  #


end
