class AddWhatToAssetWorkTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :asset_work_transactions, :reason, :string
  end
end
