#encoding: utf-8
class Admin::ReasonsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin, :supervisor], root_path)}
  
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

  def create
    @reason = Reason.new(params[:reason])
    if @reason.save
      flash['success'] = 'Nueva razón creada'
    else
      flash['error'] = @reason.errors.full_messages.to_sentence
    end
    redirect_to admin_reasons_path
  end

  def show
    @reason = Reason.find params[:id]
    @carts = @reason.carts.page(params[:page])
  end
end
