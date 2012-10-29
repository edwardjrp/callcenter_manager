class Admin::AddressesController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    @cities = City.order(:name).all
  end

  def new
  end

  def show
  end
end
