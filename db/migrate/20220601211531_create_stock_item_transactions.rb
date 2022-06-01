class CreateStockItemTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_item_transactions do |t|
      t.references :stocked_product, null: false, foreign_key: true
      t.references :stock_location, null: false, foreign_key: true
      t.references :stock_item, null: false, foreign_key: true
      t.integer :quantity
      t.string :unit
      t.string :barcodes

      t.timestamps
    end
  end
end
