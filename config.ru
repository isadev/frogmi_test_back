# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
require 'active_record'
require 'json'
require 'httparty'

require ::File.expand_path('../config/environment',  __FILE__)
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'storage/development.sqlite3')


# TODO: extract this code to the model
load_ddbb = Earthquake.first.id == "ak02410bcznp8"
puts  load_ddbb ? "Data previously exist, skip loading!" : ""

unless Earthquake.exists?(id: "ak0244or92hk")
  response = HTTParty.get('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')

  if response.success?
    data = JSON.parse(response.body)
    
    new_features = data['features'].map do |feature|
      if not feature['properties']['title'].nil? and not feature['properties']['url'].nil? and not 
        feature['properties']['magType'].nil? and not feature['geometry']['coordinates'].nil? and not 
        feature['geometry']['coordinates'].empty? 
        {
            place: feature['properties']['place'],
            magnitude: feature['properties']['mag'],
            id: feature['id'],
            external_id: feature['properties']['ids'],
            tsunami: feature['properties']['tsunami'],
            mag_type: feature['properties']['magType'],
            title: feature['properties']['title'],
            time: Time.at(feature['properties']['time'] / 1000), # Convert Unix timestamp to Ruby time
            latitude: feature['geometry']['coordinates'][1],
            longitude: feature['geometry']['coordinates'][0]
        }        
      end
    end

    Earthquake.insert_all(new_features) unless new_features.empty?

    puts "Data loaded successfully"
  else
    # Manejo de errores si la solicitud no fue exitosa
    puts 'Failed to fetch data from USGS'
  end
end

run Rails.application


# run Rails.application
# Rails.application.load_server
