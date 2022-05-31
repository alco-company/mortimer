class ParticipantTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :participant_teams do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :team_role, default: "member"

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
