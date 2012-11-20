class Admin::AddressesController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    @cities = City.order(:name).all
    @streets = Address.find_address(params[:q]).try(:paginate, {per_page: 20, page: params[:page]})
  end

  def new
  end

  def show
  end
end
