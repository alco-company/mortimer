class CreateDashboards < ActiveRecord::Migration[7.0]
  def change
    create_table :dashboards do |t|
      t.string :name
      t.string :layout
      t.text :body

      t.datetime "deleted_at"
      t.timestamps
    end
  end
end
