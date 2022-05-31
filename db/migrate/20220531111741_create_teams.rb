class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :task, null: true, foreign_key: true
      t.references :calendar, null: true, foreign_key: true

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
