class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :job_title
      t.references :participant, null: true, foreign_key: true

      t.timestamps
    end
  end
end
