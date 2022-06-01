class CreateStockItems < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_items do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :stocked_product, null: false, foreign_key: true
      t.references :stock_location, null: false, foreign_key: true
      t.string :batch_number
      t.datetime :expire_at
      t.integer :quantity
      t.string :batch_unit

      t.timestamps
    end
  end
end
