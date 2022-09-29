class CreateAssetWorkdaySums < ActiveRecord::Migration[7.0]
  def change
    create_table :asset_workday_sums do |t|
      t.references :account, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true
      t.date :work_date
      t.integer :work_minutes
      t.integer :break_minutes
      t.integer :ot1_minutes
      t.integer :ot2_minutes
      t.integer :sick_minutes
      t.integer :free_minutes
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
