json.extract! stock_item, :id, :stock_id, :stocked_product_id, :stocked_location_id, :batch_number, :expire_at, :quantity, :batch_unit, :created_at, :updated_at
json.url stock_item_url(stock_item, format: :json)
