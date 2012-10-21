class Admin::CouponsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}

  def index
    @search = Coupon.search(params[:q])
    @coupons = @search.result.page(params[:page])
  end

  # def show
  #   @coupon = Coupon.find(params[:id])
  # end

  def edit
    @coupon = Coupon.find(params[:id])
  end
end
