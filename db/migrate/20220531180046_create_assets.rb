class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.references :account, null: false, foreign_key: true
      t.references :assetable, polymorphic: true, null: false
      t.references :calendar, null: true, foreign_key: true
      t.string :name
      t.string :state
      t.integer :position
      t.string :ancestry

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :assets, :name
  end
end
