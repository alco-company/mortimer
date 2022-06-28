class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :time_zone
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
