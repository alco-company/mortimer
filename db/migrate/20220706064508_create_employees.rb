class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :access_token
      t.string :job_title
      t.string :pin_code
      t.datetime :birthday
      t.datetime :hired_at
      t.integer :base_salary
      t.text :description

      t.timestamps
    end
  end
end
