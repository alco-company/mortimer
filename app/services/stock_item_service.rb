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
    sp.update_attribute :quantity, (sp.quantity - st.quantity) unless sp.id.nil?
    sl = st.stock_location
    si = StockItem.find_by( stocked_product_id: sp.id, stock_location: sl.id, batch_number: parm["batchnbr"])
    if si 
      si.update_attribute :quantity, (si.quantity - st.quantity)
    else
      # no StockItem - must be an error so we create one with the quantity
      unless s.id.blank? || sp.id.blank? || sl.id.blank?
        si = create_stock_item( s, sp, sl, parm)
        # and then we update the quantity to zero to have our version log intact
        si.update_attribute :quantity, 0
      end
    end
    si
  end

  def create_stock_item s, sp, sl, parm 
    begin      
      acc = Asset.unscoped.where( assetable: s).first.account
      expire = (StockItem.parse_yymmdd( parm["expr"] )) || (StockItem.parse_yymmdd( parm["sell"] )) || nil
      unit = parm["unit"] || 'pcs'
      quantity = parm["nbrcont"].to_i || 1
      batchnbr = parm["batchnbr"] || "%s_%s" % [ sp.name, DateTime.now ]
      Asset.create( 
        account_id: acc.id, 
        name: parm["batchnbr"], 
        assetable: StockItem.create( 
          stock_id: s.id,
          stocked_product_id: sp.id, 
          stock_location_id: sl.id, 
          batch_number: batchnbr, 
          quantity: quantity,
          batch_unit: unit,
          expire_at: expire
        )
      ).assetable
    rescue => exception      
      Rails.logger.warn "create_stock_item! s (#{s}), sp (#{sp}), sl (#{sl}), parm(#{parm})"
      puts exception 
      nil
    end 
  end

end