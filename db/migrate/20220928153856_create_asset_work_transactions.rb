class CreateAssetWorkTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :asset_work_transactions do |t|
      t.references :asset, null: false, foreign_key: true
      t.bigint :asset_workday_sum_id
      t.bigint :punch_asset_id
      t.string :punch_asset_ip_addr
      t.datetime :punched_at
      t.integer :extra_time

      t.timestamps
    end
  end
end
