json.extract! background_job, :id, :execute_at, :work, :params, :job_id, :created_at, :updated_at
json.url background_job_url(background_job, format: :json)
