class Admin::AreasController < ApplicationController
  respond_to :json
  def index
    @city = City.find_by_id(params[:city_id])
    if params[:city_id]
      respond_with @city.areas
    else
      respond_with Areas.all
    end
  end
end
