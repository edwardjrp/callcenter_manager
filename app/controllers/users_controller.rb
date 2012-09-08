class UsersController < ApplicationController
  def index
    @user = current_user
    @carts = @user.carts
  end
end
