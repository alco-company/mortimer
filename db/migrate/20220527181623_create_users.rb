class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :account, null: false, foreign_key: true
      t.string :user_name
      t.string :email
      t.datetime :confirmed_at
      t.string :password_digest
      t.string :unconfirmed_email
      t.string :remember_token
      t.string :session_token
      t.datetime :logged_in_at
      t.datetime :on_task_since_at

      t.timestamps
    end
  end
end
