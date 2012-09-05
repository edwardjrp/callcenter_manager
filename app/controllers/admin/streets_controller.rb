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

  def create
    @area = Area.find_by_id(params[:street][:area_id])
    @street = @area.streets.new(:name=> params[:street][:name])
    respond_to do |format|
      if @street.save
        format.json{ render json: @street}
      else
        format.json{ render json: @street.errors.full_message.to_sentence}
      end
    end
  end
end
