json.extract! employee, :id, :job_title, :birthday, :base_salary, :description, :created_at, :updated_at
json.url employee_url(employee, format: :json)
