require 'active_record'
require 'json'
require 'httparty'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'storage/development.sqlite3')

namespace :db do
    desc "Principal task to load for unique time the earthquakes data"
    # "=> :environment" indicates that a config must be execute before the method call, this action is the load of environments that includes the ddbb models and more
    task :load_earthquakes => :environment do 
        load_ddbb = Earthquake.any?
        puts  load_ddbb ? "Data previously exist, skip loading!" : ""

        if not load_ddbb
            response = HTTParty.get('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')

            if response.success?
                data = JSON.parse(response.body)
                
                new_features = data['features'].map do |feature|
                    if not feature['properties']['title'].nil? and not feature['properties']['url'].nil? and not 
                        feature['properties']['magType'].nil? and not feature['geometry']['coordinates'].nil? and not 
                        feature['geometry']['coordinates'].empty? 

                        magnitude = feature['properties']['mag'].round(1)
                        truncated_magnitude = limit_magnitude(magnitude)
                        
                        longitude = feature['geometry']['coordinates'][0]
                        truncated_longitude = limit_longitud(longitude)

                        latitude = feature['geometry']['coordinates'][1]
                        truncated_latitude = limit_longitud(latitude)

                        {
                            type_of: feature["type"],
                            external_url: feature['properties']["detail"],
                            place: feature['properties']['place'],
                            magnitude: truncated_magnitude,
                            external_id: feature['id'],
                            ids: feature['properties']['ids'],
                            tsunami: feature['properties']['tsunami'],
                            mag_type: feature['properties']['magType'],
                            title: feature['properties']['title'],
                            time: Time.at(feature['properties']['time'] / 1000), # Convert Unix timestamp to Ruby time
                            longitude: truncated_longitude,
                            latitude: truncated_latitude
                        }
                    else
                        nil
                    end
                end.compact

                Earthquake.insert_all(new_features) unless new_features.empty?

                puts "Data loaded successfully"
            else
                # Manejo de errores si la solicitud no fue exitosa
                puts 'Failed to fetch data from USGS'
            end
        end
    end
end

private
def limit_magnitude(magnitude)
    truncated_magnitude = [magnitude, -1.0].max
    truncated_magnitude = [truncated_magnitude, 10.0].min

    truncated_magnitude
end

def limit_longitud(longitude)
    truncated_longitude = [longitude, -180.0].max
    truncated_longitude = [truncated_longitude, 180.0].min
    
    truncated_longitude
end
    
def limit_latitude(latitude)  
    truncated_latitude = [latitude, -90.0].max
    truncated_latitude = [truncated_latitude, 90.0].min
  
end