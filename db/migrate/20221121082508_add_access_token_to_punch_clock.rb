class AddAccessTokenToPunchClock < ActiveRecord::Migration[7.0]
  def change
    add_column :punch_clocks, :access_token, :string
  end
end
