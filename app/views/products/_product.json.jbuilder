json.extract! product, :id, :supplier_id, :supplier_barcode, :created_at, :updated_at
json.url product_url(product, format: :json)
