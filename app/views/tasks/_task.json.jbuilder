json.extract! task, :id, :duration, :planned_start_at, :planned_end_at, :location, :purpose, :recurring_ical, :recurring_end_at, :full_day, :created_at, :updated_at
json.url task_url(task, format: :json)
