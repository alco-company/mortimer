class RemoveProductsFkFromSuppliers < ActiveRecord::Migration[7.0]
  def change
    if foreign_key_exists?(:products, :suppliers)
      remove_foreign_key :products, :suppliers
    end
  end
end
