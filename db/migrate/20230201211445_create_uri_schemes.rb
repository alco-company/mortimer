class CreateUriSchemes < ActiveRecord::Migration[7.0]
  def change
    create_table :uri_schemes do |t|
      t.string :scheme
      t.string :purpose
      t.string :state
      t.string :reference
      t.string :general_format
      t.text :notes

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
