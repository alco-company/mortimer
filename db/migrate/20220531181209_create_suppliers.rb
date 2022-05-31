class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.string :product_resource
      t.string :gtin_prefix

      t.timestamps
    end
  end
end
