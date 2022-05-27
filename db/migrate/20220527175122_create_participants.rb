class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :account, null: false, foreign_key: true
      t.references :participantable, polymorphic: true, null: false
      t.bigint :calendar_id, default: 0
      t.string :name
      t.string :state
      t.string :ancestry

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
