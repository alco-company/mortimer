class AddActiveToBackgroundJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :background_jobs, :active, :boolean
  end
end
