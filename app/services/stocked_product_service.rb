class StockedProductService < AssetService

  # def get_by field, s, parm 
  #   unscoped.find_by(field => parm["ean14"]) || create_stocked_product( s, parm)
  # end

  # prod is the asset product - 
  def create_stocked_product s, prod, sl, parm
    acc = s.account
    a = Asset.create( 
      account_id: acc.id, 
      name: "%s (%s)" % [prod.name, parm["batchnbr"]], 
      assetable: StockedProduct.create( 
        stock_id: s.id, 
        product_id: prod.assetable.id, 
        stock_location_id: sl.id,
        stock_unit: parm["unit"]
      )
    )
    a.assetable
  end

end