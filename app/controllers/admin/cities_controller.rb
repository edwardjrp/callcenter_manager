class Admin::CitiesController < ApplicationController

  def create
    @city= City.new(params[:city])
  end
end
