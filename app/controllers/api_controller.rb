require 'httparty'

class ApiController < ApplicationController
  # before_action :review_params, only: [:show]

  def features
    max_page = (params[:per_page].present? and (params[:per_page] < 1000)) ? params[:per_page] : 2
    page = params[:page] ? params[:page] : 1
    
    
    # instance variable to handle in the view and to access to other attr, like has_next_page
    earthquakeQuery = Earthquake.all
    
    if params[:mag_types].present?
      mag_types = [params[:mag_types]] unless mag_types.is_a?(Array) # Convertir a un arreglo si no lo es
      earthquakeQuery = earthquakeQuery.where(mag_type: mag_types)
    end
    
    @earthquakes = earthquakeQuery.paginate(page: page, per_page: max_page)

    if @earthquakes.any?
      data_from_ddbb = @earthquakes.map do |earthquake|
        {
          "id": earthquake.id,
          "type": earthquake.type_of,
          "attributes": {
            "external_url": earthquake.external_url,
            "external_id": earthquake.external_id,
            "magnitude": earthquake.magnitude,
            "place": earthquake.place,
            "time": earthquake.time,
            "tsunami": earthquake.tsunami,
            "mag_type": earthquake.mag_type,
            "title": earthquake.title,
            "coordinates": {
              "longitude": earthquake.longitude,
              "latitude": earthquake.latitude
            }
          }
        }
      end

      prev_page = @earthquakes.current_page > 1 ? @earthquakes.current_page - 1 : nil
      render json: { 
        data: data_from_ddbb, 
        total_pages: @earthquakes.total_pages,
        current_page: @earthquakes.current_page,
        next_page: @earthquakes.next_page,
        prev_page: prev_page,
        total_entries: @earthquakes.total_entries
      }
    else
      render json: { error: "No data found" }, status: :not_found
    end

  end


  private
    def review_params
      # ...
    end
end
