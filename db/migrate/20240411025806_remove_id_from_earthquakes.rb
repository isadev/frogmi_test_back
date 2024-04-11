class RemoveIdFromEarthquakes < ActiveRecord::Migration[7.1]
  def change
    remove_column :earthquakes, :id
  end
end
