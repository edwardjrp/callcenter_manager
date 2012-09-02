class Admin::CitiesController < ApplicationController

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
end
