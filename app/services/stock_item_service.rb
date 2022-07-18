class StockItemService < AssetService

  # add quantity to existing stock_item
  # provide s(tock), s(tocked_)p(roduct), s(tock_)l(ocation), parm
  #
  def add_quantity( s, sp, sl, parm)
    begin      
      si = StockItem.unscoped.find_by( stocked_product_id: sp.id, stock_location: sl.id, batch_number: parm["batchnbr"])
      if si 
        si.update_attribute :quantity, (si.quantity + parm["nbrcont"].to_i)
      else
        si = create_stock_item( s, sp, sl, parm)
      end
      si
    rescue => exception
      raise ActiveRecord::Rollback
      nil
    end
  end

  def subtract_quantity( s, st, parm)
    sp = st.stocked_product
    sl = st.stock_location
    si = self.find_by( stocked_product_id: sp.id, stock_location: sl.id, batch_number: parm["batchnbr"])
    if si 
      si.update_attribute :quantity, (si.quantity - st.quantity)
    else
      si = self.create_for_stock_item_transaction( s, sp, sl, parm)
      si.update_attribute :quantity, 0
    end
    si
  end

  def create_stock_item s, sp, sl, parm 
    begin      
      acc = Asset.unscoped.where( assetable: s).first.account
      expire = StockItem.parse_yymmdd( parm["expr"] ) || StockItem.parse_yymmdd( parm["sell"] ) || nil
      Asset.create( 
        account_id: acc.id, 
        name: parm["batchnbr"], 
        assetable: StockItem.create( 
          stock_id: s.id,
          stocked_product_id: sp.id, 
          stock_location_id: sl.id, 
          batch_number: parm["batchnbr"], 
          quantity: parm["nbrcont"],
          batch_unit: parm["unit"],
          expire_at: expire
        )
      ).assetable
    rescue => exception      
      puts exception 
      nil
    end 
  end

end