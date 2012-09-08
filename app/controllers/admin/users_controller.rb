class Admin::UsersController < ApplicationController
  def index
    @users = User.page(params[:page])
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @carts = @user.carts
  end
end
