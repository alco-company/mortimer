class AddPunchedGeoToPupilTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :pupil_transactions, :punched_geo, :string
  end
end
