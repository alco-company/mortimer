class AssetTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :asset_teams do |t|
      t.references :asset, null: false
      t.references :team, null: false
      t.string :team_role, default: "member"

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
