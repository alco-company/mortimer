class AddNormTimeToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :norm_time, :integer
  end
end
