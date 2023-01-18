class RemoveDeletedAtFromPunchClock < ActiveRecord::Migration[7.0]
  def change
    remove_column :punch_clocks, :deleted_at
    remove_column :teams, :deleted_at
  end
end
