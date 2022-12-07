class AddPbxExtensionToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :pbx_extension, :string
  end
end
