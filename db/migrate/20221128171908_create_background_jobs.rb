class CreateBackgroundJobs < ActiveRecord::Migration[7.0]
  def change
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
end
