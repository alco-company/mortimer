class CreateEmployeesPupils < ActiveRecord::Migration[7.0]
  def change
    create_join_table :employees, :pupils do |t|
      t.index [:employee_id, :pupil_id]
      t.index [:pupil_id, :employee_id]
    end
  end
end
