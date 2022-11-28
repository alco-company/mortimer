class AddPincodeToPupil < ActiveRecord::Migration[7.0]
  def change
    add_column :pupils, :pin_code, :string
  end
end
