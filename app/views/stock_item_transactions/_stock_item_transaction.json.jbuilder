json.extract! stock_item_transaction, :id, :stocked_product_id, :stock_location_id, :stock_item_id, :quantity, :unit, :barcodes, :created_at, :updated_at
json.url stock_item_transaction_url(stock_item_transaction, format: :json)
