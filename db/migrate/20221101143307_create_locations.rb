class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :long_lat
      t.text :asset_requirements

      t.timestamps
    end
  end
end
