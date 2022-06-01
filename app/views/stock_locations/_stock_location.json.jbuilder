json.extract! stock_location, :id, :stock_id, :location_barcode, :open_shelf, :shelf_size, :created_at, :updated_at
json.url stock_location_url(stock_location, format: :json)
