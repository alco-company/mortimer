class CreateWorkSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :work_schedules do |t|
      t.boolean :roll
      t.integer :start_minute
      t.integer :end_minute

      t.timestamps
    end
  end
end
