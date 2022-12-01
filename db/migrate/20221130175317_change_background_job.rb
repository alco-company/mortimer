class ChangeBackgroundJob < ActiveRecord::Migration[7.0]

  # before
  # t.bigint "account_id", null: false
  # t.text "execute_at"
  # t.text "work"
  # t.text "params"
  # t.text "job_id"
  def down
    drop_table :background_jobs
    create_table :background_jobs do |t|
      t.references :account, null: false, foreign_key: true
      t.text :execute_at
      t.text :work
      t.text :params
      t.text :job_id

      t.datetime :deleted_at
      t.timestamps
    end
  end

  # after
  # t.bigint "account_id", null: false
  # t.bigint "user_id", null: false
  # t.string "klass"
  # t.text "params"
  # t.text "schedule"
  # t.datetime "next_run_at"
  # t.string "job_id"
  def up
    drop_table :background_jobs
    create_table :background_jobs do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :klass
      t.text :params
      t.text :schedule
      t.datetime :next_run_at
      t.string :job_id

      t.datetime :deleted_at
      t.timestamps
    end

  end
end
