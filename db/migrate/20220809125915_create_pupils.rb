class CreatePupils < ActiveRecord::Migration[7.0]
  def change
    create_table :pupils do |t|
      t.integer :time_spent_minutes
      t.string :location

      t.timestamps
    end
  end
end
