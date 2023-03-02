class RemoveSupplierIdFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :supplier_id, :bigint
    add_column :products, :organization_id, :bigint

    add_index :products, :organization_id
  end
end
