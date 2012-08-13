class Admin::AddressesController < ApplicationController
  def index
    @cities = City.all
  end

  def new
  end

  def show
  end
end
