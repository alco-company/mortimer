class AddAzureToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :tenant_id, :string
    add_column :accounts, :app_id, :string
    add_column :accounts, :app_secret, :string
  end
end
