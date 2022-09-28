class CreateSystemParameters < ActiveRecord::Migration[7.0]
  def change
    create_table :system_parameters do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.string :system_key
      t.integer :position
      t.string :value
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
