class AddIdToEarthquakes < ActiveRecord::Migration[7.1]
  def change
    add_column :earthquakes, :id, :string, primary_key: true
  end
end
