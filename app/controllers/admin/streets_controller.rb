class Admin::StreetsController < ApplicationController
  respond_to :json
  def index
    @area = Area.find_by_id(params[:area_id])
    if params[:area_id]
      respond_with @area.streets
    else
      respond_with Streets.all
    end
  end
end
