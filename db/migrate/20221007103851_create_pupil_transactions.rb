class CreatePupilTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :pupil_transactions do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :pupil, null: false, foreign_key: true
      t.string :state
      t.datetime :punched_at
      t.integer :work_minutes

      t.timestamps
    end
  end
end
