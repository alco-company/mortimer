json.extract! pupil_transaction, :id, :asset_id, :pupil_id, :work_minutes, :created_at, :updated_at
json.url pupil_transaction_url(pupil_transaction, format: :json)
