json.extract! product, :id, :organization_id, :supplier_barcode, :created_at, :updated_at
json.url product_url(product, format: :json)
