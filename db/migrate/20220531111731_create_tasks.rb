class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.integer :duration
      t.datetime :planned_start_at
      t.datetime :planned_end_at
      t.string :location
      t.string :purpose
      t.text :recurring_ical
      t.datetime :recurring_end_at
      t.boolean :full_day

      t.timestamps
    end
  end
end
