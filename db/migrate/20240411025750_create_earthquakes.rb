class CreateEarthquakes < ActiveRecord::Migration[7.1]
  def change
    create_table :earthquakes do |t|
      t.string :external_url
      t.string :type_of
      t.string :external_id
      t.string :ids
      t.float :magnitude
      t.string :place
      t.string :time
      t.boolean :tsunami
      t.string :mag_type
      t.string :title
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
