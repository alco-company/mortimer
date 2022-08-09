json.extract! pupil, :id, :account_id, :time_spent_minutes, :location, :state, :deleted_at, :created_at, :updated_at
json.url pupil_url(pupil, format: :json)
