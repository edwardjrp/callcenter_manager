class Admin::CartsController < ApplicationController
  def index
    @carts = Cart.page(params[:page])
  end

  def show
  end
end
