class UsersController < ApplicationController
  def index
    @user = current_user
    if params[:search].present? && ['completed', 'incomplete', 'abandoned', 'comm_failed'].include?(params[:search])
      @carts = @user.carts.filter_carts(params[:search]).order('complete_on DESC').page(params[:page])
    else
      @carts = @user.carts.order('complete_on DESC').page(params[:page])
    end
  end
end
