json.extract! stocked_product, :id, :product_id, :stock_id, :stock_location_id, :quantity, :stock_unit, :created_at, :updated_at
json.url stocked_product_url(stocked_product, format: :json)
