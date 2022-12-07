class AddPunchedGeoToAssetWorkTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :asset_work_transactions, :punched_geo, :string
  end
end
