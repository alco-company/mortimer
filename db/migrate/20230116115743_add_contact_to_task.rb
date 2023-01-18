class AddContactToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :contact, :bigint, null: true
    add_column :tasks, :invoice_to, :bigint, null: true # either contact or other participant (supplier/customer)
  end
end
