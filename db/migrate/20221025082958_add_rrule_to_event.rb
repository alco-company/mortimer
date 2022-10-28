class AddRruleToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :rrule, :text
    add_column :events, :first_occurence, :datetime
    add_column :events, :last_occurence, :datetime
  end
end
