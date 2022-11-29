class AddFieldsToAssetWorkdaySum < ActiveRecord::Migration[7.0]
  def change
    add_column :asset_workday_sums, :holiday_free_minutes, :integer
    add_column :asset_workday_sums, :child_sick_minutes, :integer                # t.integer "" - Barns 1. sygedag
    add_column :asset_workday_sums, :nursing_minutes, :integer                 # t.integer "" - Omsorgsdage
    add_column :asset_workday_sums, :senior_minutes, :integer                # t.integer "" - Seniordage
    add_column :asset_workday_sums, :unpaid_free_minutes, :integer                 # t.integer "" - Fri uden løn
    add_column :asset_workday_sums, :lost_work_revenue_minutes, :integer                 # t.integer "" - Tabt arbejdsfortjeneste
    add_column :asset_workday_sums, :child_leave_minutes, :integer                 # t.integer "" - Barselsorlov
    add_column :asset_workday_sums, :leave_minutes, :integer                 # t.integer "" - Orlov (sygdom forældre eller ægtefælle)
  end
end
