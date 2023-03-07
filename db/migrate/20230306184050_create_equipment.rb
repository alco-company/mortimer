class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :equipment do |t|
      t.string :access_token
      t.text :description
      t.datetime :bought_at
      
      t.timestamps
    end
  end
end
