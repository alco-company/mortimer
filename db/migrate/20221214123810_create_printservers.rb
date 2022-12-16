class CreatePrintservers < ActiveRecord::Migration[7.0]
  def change
    create_table :printservers do |t|
      t.string :mac_addr
      t.integer :port

      t.timestamps
    end
  end
end
