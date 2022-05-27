class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :dashboard, null: false, foreign_key: true
      t.string :name
      t.string :state
      t.bigint :calendar_id, default: 0

      t.datetime :deleted_at
      t.timestamps
    end
  end
end

