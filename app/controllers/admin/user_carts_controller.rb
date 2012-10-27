class Admin::UserCartsController < ApplicationController
  def create
    @cart = Cart.find(params[:cart_id])
    @user_cart = UserCart.new(cart_id: @cart.id, user_id: current_user.id)
    if @user_cart.save
      flash['success'] = 'Orden agregada a favoritos'
    else
      flash['error'] = 'Un error impidio asociar esta orden a los favoritos'
    end
      redirect_to [:admin, @cart]
  end

  def destroy
    @user_cart = UserCart.find(params[:id])
    @user_cart.destroy
    flash['success'] = 'Orden removida de favoritos'
    redirect_to :back
  end
end
