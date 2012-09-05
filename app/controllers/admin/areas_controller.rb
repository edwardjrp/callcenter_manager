class Admin::AreasController < ApplicationController
  respond_to :json
  def index
    @city = City.find_by_id(params[:city_id])
    if params[:city_id]
      respond_with @city.areas.order(:name)
    else
      respond_with Area.find_area(params).includes(:city).to_json(include: { city: {}})
    end
  end

  def create
    @city = City.find_by_id(params[:area][:city_id])
    @area = @city.areas.new(name: params[:area][:name])
    respond_to do |format|
      if @area.save
        format.json{ render json: @area}
      else
        format.json{ render json: @area.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @area =Area.find(params[:id])
    respond_to do |format|
      if @area.destroy
        format.json{ render json: {id: params[:id]}}
      else
        format.json{ render json: @area.errors.full_messages.to_sentence}
      end
    end
  end
end
