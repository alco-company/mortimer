json.extract! asset_workday_sum, :id, :account_id, :asset_id, :work_date, :work_minutes, :break_minutes, :ot1_minutes, :ot2_minutes, :sick_minutes, :free_minutes, :deleted_at, :created_at, :updated_at
json.url asset_workday_sum_url(asset_workday_sum, format: :json)
