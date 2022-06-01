class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :access_token
      t.datetime :last_heart_beat_at

      t.timestamps
    end
    add_index :stocks, :access_token, unique: true 
  end
end
