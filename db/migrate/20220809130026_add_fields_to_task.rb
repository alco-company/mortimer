class AddFieldsToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :started_at, :datetime
    add_column :tasks, :ended_at, :datetime
  end
end
