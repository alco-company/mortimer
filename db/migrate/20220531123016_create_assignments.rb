class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.references :event, null: false, foreign_key: true
      t.references :assignable, polymorphic: true, null: false
      t.string :assignable_role

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
