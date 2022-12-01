class AddFreePrevToAssetWorkdaySum < ActiveRecord::Migration[7.0]
  def change
    add_column :asset_workday_sums, :free_prev_minutes, :integer
    add_column :asset_workday_sums, :pgf56_minutes, :integer
  end
end
