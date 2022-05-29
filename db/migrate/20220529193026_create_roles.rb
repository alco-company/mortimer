class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.string :ancestry
      t.string :context
      t.integer :position
      t.string :state
      t.string :role

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
