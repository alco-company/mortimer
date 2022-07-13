class ProductService < AssetService

  def get_by field, s, parm 
    unscoped.find_by(field => parm["ean14"]) || create_product( s, parm)
  end

  def create_product s, parm 
    acc = Asset.unscoped.where(assetable: s).first.account
    sup = SupplierService.new.find_by :supplier_barcode, acc, parm
    prod = Product.new( supplier: sup, supplier_barcode: parm["ean14"] )
    resource = Asset.new account: acc, name: parm["ean14"], assetable: prod
    result = create(resource, Product)
    return result.record if result.created?
    nil
    # a= Asset.create!( 
    #   account_id: acc.id, 
    #   name: parm["ean14"], 
    #   assetable: prod
    # )
    # Product.find a.assetable.id
  end
  
  def get_stocked_product s, sl, prod, parm
    sp = prod.stocked_products.where(stock: s).first 
    if sp.nil?
      sp = StockedProduct.create_for_stock_item_transaction( s, prod, sl, parm)
    end
    sp
  end

end