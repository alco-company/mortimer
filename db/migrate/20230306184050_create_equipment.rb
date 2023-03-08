class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :equipment do |t|
      t.string :access_token      
      t.string :brand
      t.string :model
      t.bigint :location_id
      t.string :organization_id
      t.datetime :purchased_at
      t.integer :purchase_price
      t.integer :residual_value
      t.datetime :warranty_ends_at
      t.string :serial_number
      t.text :description
      
      t.timestamps
    end
  end
end
