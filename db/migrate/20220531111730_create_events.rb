class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :account, null: false, foreign_key: true
      t.references :eventable, polymorphic: true, null: false
      t.references :calendar, null: false, foreign_key: true
      t.string :name
      t.string :state
      t.integer :position
      t.string :ancestry
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :minutes_spent
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
