class Admin::ReasonsController < ApplicationController
  def index
    @reasons = Reason.order('created_at DESC').page(params[:page])
  end

  def update
    @reason = Reason.find params[:id]
    respond_to do |format|
      if @reason.update_attributes(params[:reason])
        format.json{ respond_with_bip(@reason)}
      else
        format.json{ respond_with_bip(@reason)}
      end
    end
  end

  def show
    @reason = Reason.find params[:id]
    @carts = @reason.carts.page(params[:page])
  end
end
