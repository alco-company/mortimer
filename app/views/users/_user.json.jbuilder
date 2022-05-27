json.extract! user, :id, :account_id, :user_name, :email, :confirmed_at, :password_digest, :unconfirmed_email, :remember_token, :session_token, :logged_in_at, :on_task_since_at, :created_at, :updated_at
json.url user_url(user, format: :json)
