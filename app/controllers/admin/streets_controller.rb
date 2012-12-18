class Admin::StreetsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin, :supervisor], root_path)}
  respond_to :json
  def index
    @area = Area.find_by_id(params[:area_id])
    if params[:area_id]
      respond_with @area.streets.order(:name)
    else
      respond_with Street.all
    end
  end

  def create
    @area = Area.find_by_id(params[:street][:area_id])
    @street = @area.streets.new(:name=> params[:street][:name])
    respond_to do |format|
      if @street.save!
        format.json{ render json: @street}
      else
        format.json{ render json: @street.errors.full_messages.to_sentence, status: 422}
      end
    end
  end

  def update
    @street = Street.find(params[:id])
    respond_to do |format|
      if @street.update_attributes(params[:street])
        format.json{ render json: @street}
      else
        format.json{ render json: @street.errors.full_messages.to_sentence, status: 422}
      end
    end
  end

  def destroy
    @street = Street.find(params[:id])
    respond_to do |format|
      if @street.destroy
        format.json{ render json: {id: params[:id]}}
      else
        format.json{ render json: @street.errors.full_messages.to_sentence}
      end
    end
  end

  def merge
    @street_destination = Street.find(params[:id])
    @street_origin = Street.find(params[:origin_id])
    respond_to do |format|
      if Address.update_all({street_id: @street_destination.id}, {street_id: @street_origin.id })
        @street_origin.destroy
        format.json{ render json: {id: params[:origin_id]}}
      else
        format.json{ render json: @street_origin.errors.full_messages.to_sentence}
      end
    end
  end

end
