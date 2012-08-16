class Admin::CartsController < ApplicationController
  def index
    @search = Cart.search(params[:q])
    @carts= @search.result.page(params[:page])
  end

  def show
    raise Exception.new (' Wrong number of arguments 1 for 0')
  end
end
