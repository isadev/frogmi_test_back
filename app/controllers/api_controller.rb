require 'httparty'

class ApiController < ApplicationController

  # before_action :review_params, only: [:show]

  # 
  def features
    apiResponse = HTTParty.get('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')
    
    #
    # for feature in apiResponse.data.features
    #   # if ()
    # end
    

    if apiResponse.success?
      data = JSON.parse(apiResponse.body)
      feature = data['features'][0]

      feature['properties']['title'] = nil
      feature['properties']['url'] = nil
      feature['geometry']['coordinates'] = []
      
      if feature['properties']['title'].nil? or feature['properties']['url'].nil? or 
        feature['properties']['magType'].nil? or feature['geometry']['coordinates'].nil? or 
        feature['geometry']['coordinates'].empty?
        
        puts "es nulo o vacio"
      end

      # Imprimimos la información del primer feature
      puts "Place: #{feature['properties']['place']}"

      render json: { data: "ok", params: params,  features: data['features']}
      # render json: { data: data?.features[0], params: params }
    else
      render json: { error: 'Failed to fetch data from USGS' }, status: :unprocessable_entity
    end
  end


  private
    def review_params
      # ...
    end

    def task_params
      # ...
    end
end
