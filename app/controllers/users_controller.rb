class UsersController < ApplicationController
  def index
    @user = current_user
    @carts = @user.carts.completed.order('complete_on DESC').page(params[:page])
  end
end
