class CreateStockLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_locations do |t|
      t.references :stock, null: false, foreign_key: true
      t.string :location_barcode
      t.boolean :open_shelf
      t.integer :shelf_size

      t.timestamps
    end
  end
end
