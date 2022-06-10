class RemoveCalendarFromTeam < ActiveRecord::Migration[7.0]
  def change
    remove_column :teams, :calendar_id
  end
end
