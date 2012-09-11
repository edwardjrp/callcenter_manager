class Admin::CitiesController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    respond_to do |format|
      format.json{ render json: City.all}
    end
  end

  def create
    @city= City.new(params[:city])
    respond_to do |format|
      if @city.save
        format.json{ render json: @city}
      else
        format.json{ render json: @city.errors.full_messages.to_sentence, status: 422}
      end
    end
  end

  def destroy
    @city = City.find(params[:id])
    respond_to do |format|
      if @city.destroy
        format.json{ render json: {id: params[:id]}}
      else
        format.json{ render json: @city.errors.full_messages.to_sentence}
      end
    end
  end
end
