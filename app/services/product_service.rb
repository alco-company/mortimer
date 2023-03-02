class ProductService < AssetService

  def get_by field, s, parm 
    (Product.unscoped.find_by(field => parm["ean14"]).asset rescue nil) || create_product( s, parm)
  end

  def new_product account 
    prod = Product.new
    Asset.new account: account, assetable: prod
  end

  # def create_product s, parm 
  #   acc = Asset.unscoped.where(assetable: s).first.account
  #   sup = SupplierService.new.get_by :supplier_barcode, acc, parm
  #   prod = Product.new( supplier: sup, supplier_barcode: parm["ean14"] )
  #   resource = Asset.new account: acc, name: parm["ean14"], assetable: prod
  #   result = create(resource)
  #   return result.record if result.created?
  #   nil
  # end

  # def update resource, resource_params
  #   result = super(resource, resource_params)
  #   if result.updated?
  #     resource.assetable.stocked_products.each{ |r| r.asset.update name: resource.name } if resource.assetable and resource.assetable.stocked_products.any?
  #   end
  #   result
  # end
  
  def get_stocked_product s, sl, prod, parm
    return nil if prod.nil? or prod.assetable.nil?
    sp = prod.assetable.stocked_products.where(stock: s).first rescue nil
    if sp 
      sp.update_attribute :quantity, (sp.quantity+parm["nbrcont"].to_i)
    else
      sp = StockedProductService.new.create_stocked_product( s, prod, sl, parm)
    end
    sp
  end

end