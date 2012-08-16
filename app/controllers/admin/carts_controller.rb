class Admin::CartsController < ApplicationController
  def index
    @search = Cart.search(params[:q])
    @carts= @search.result.page(params[:page])
  end

  def show
  end
end
