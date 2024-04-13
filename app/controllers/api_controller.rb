require 'httparty'

class ApiController < ApplicationController

  def features
    max_page = (params[:per_page].present? and (params[:per_page].to_i < 1000)) ? params[:per_page].to_i : 10
    page = params[:page] ? params[:page].to_i : 1
    
    
    # instance variable to handle in the view and to access to other attr, like has_next_page
    earthquakeQuery = Earthquake.all
    
    if params[:mag_type].present?
      mag_type = [params[:mag_type]] unless mag_type.is_a?(Array) # Converter to an array if it is not one
      earthquakeQuery = earthquakeQuery.where(mag_type: mag_type)
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

  def new_comment
    earthquake = Earthquake.find(params[:id])

    if request.body.read.empty?
      render json: { error: "Comments need a body" }, status: :forbidden
      return
    end

    comment_data = JSON.parse(request.body.read)

    if earthquake.nil?
      render json: { error: "No data found" }, status: :not_found
      return
    end


    if comment_data.nil? or comment_data["body"].nil? or comment_data["body"].empty?
      render json: { error: "Comments cannot be empty" }, status: :forbidden
      return
    end
    
    comment = earthquake.comments.build(content: comment_data["body"])

    if comment.save
      render json: comment, status: :created
    else
      render json: { error: comment.errors.full_messages }, status: :unprocessable_entity
    end

  end

end
