class CreateRoleables < ActiveRecord::Migration[7.0]
  def change
    create_table :roleables do |t|
      t.references :role, null: false, foreign_key: true
      t.references :roleable, polymorphic: true, null: false

      t.timestamps
    end    
  end
end
