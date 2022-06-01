json.extract! supplier, :id, :name, :product_resource, :gtin_prefix, :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
