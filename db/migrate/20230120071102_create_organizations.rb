class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :cvr_number
      t.string :gtin_prefix
      t.string :product_resource
      t.string :partner_roles

      t.timestamps
    end
  end
end
