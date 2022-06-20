module StockLocationsHelper

  def form_stock_location_url resource 
    if resource.new_record? 
      resource.assetable.stock.nil? ? stock_locations_url() : stock_stock_locations_url(resource.assetable.stock)
    else
      stock_stock_location_url(resource.assetable.stock, resource.assetable )
    end
  end

  def link_to_stock_location resource, options
    if parent?
      link_to( resource.asset.name, stock_stock_location_url(resource.stock,resource), options) 
    else
      link_to( resource.asset.name, stock_location_url(resource))
    end
  end

  def edit_location_href resource 
    return edit_stock_stock_location_path(resource.stock,resource) if parent? 
    edit_stock_location_path(resource)
  end

  def link_to_location_stock_items(resource)
    return stock_location_stock_items_url(resource) if parent_class == StockLocation 
    stock_stock_location_stock_items_url(resource.stock, resource)
  end

  def link_to_new_location_stock_item_url(resource)
    return new_stock_location_stock_item_url(resource) if parent_class == StockLocation 
    new_stock_stock_location_stock_item_url(resource.stock, resource)
  end

  def collect_stock_locations(stocked_product)
    locations = StockLocation.where( id: stocked_product.stock_items.pluck( :stock_location_id))
    raw locations.collect{ |l| link_to( l.name, l )}.join( ", ")
  end
end
