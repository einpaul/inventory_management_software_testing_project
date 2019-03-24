json.extract! order, :id, :quantity, :status, :expire_at, :product_id, :supplier_id, :created_at, :updated_at
json.url order_url(order, format: :json)
