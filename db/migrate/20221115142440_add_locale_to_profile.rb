class AddLocaleToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :locale, :string
  end
end
