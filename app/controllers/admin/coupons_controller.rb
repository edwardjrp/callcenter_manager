# encoding: utf-8
class Admin::CouponsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin, :supervisor], root_path)}
    before_filter :admin_protected, only: :destroy


  def index
    @search = Coupon.search(params[:q])
    @coupons = @search.result.page(params[:page])
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    if @coupon.destroy
      flash[:success] = 'Cupón eliminado'
    else
      flash[:error] = "No se pudo eliminar el Cupón: #{@coupon.errors.full_messages.to_sentence}"
    end
    redirect_to admin_coupons_path
  end

end
