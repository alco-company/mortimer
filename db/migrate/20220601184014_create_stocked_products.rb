class CreateStockedProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :stocked_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.references :stock_location, null: false, foreign_key: true
      t.integer :quantity
      t.string :stock_unit
      t.datetime :consolidated_at

      t.timestamps
    end
  end
end
