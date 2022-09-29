class CreatePunchClocks < ActiveRecord::Migration[7.0]
  def change
    create_table :punch_clocks do |t|
      t.string :location
      t.string :ip_addr
      t.datetime :last_punch_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
