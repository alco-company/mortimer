class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.string :menu_label
      t.string :index_url
      t.string :service_model
      t.string :service_group
      t.string :state
      t.text :menu_icon
      t.datetime :deleted_at

      t.timestamps
    end
    create_join_table :accounts, :services do |t|
      t.index [:account_id, :service_id]
      t.index [:service_id, :account_id]
    end

  end
end
