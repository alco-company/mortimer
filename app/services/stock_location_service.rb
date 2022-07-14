class StockLocationService < AssetService

  def get_by field, s, parm 
    StockLocation.find_by( field => parm["location"] ) || create_stock_location( s, parm )
  end
  
  def create_stock_location s, parm
    return nil if parm["location"].blank?

    begin      
      acc = s.account
      Asset.create( 
        account_id: acc.id, 
        name: parm["location"], 
        assetable: StockLocation.create( 
          stock_id: s.id, 
          location_barcode: parm["location"] 
        ) 
      ).assetable
    rescue => exception
      raise ActiveRecord::Rollback
      nil
    end
  end
  
  def get_stocked_product s, sl, prod, parm
    sp = prod.stocked_products.where(stock: s).first 
    if sp.nil?
      sp = StockedProduct.create_for_stock_item_transaction( s, prod, sl, parm)
    end
    sp
  end

end