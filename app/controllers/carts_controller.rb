#encoding: utf-8
class CartsController < ApplicationController
  def create
    @client = Client.find_by_id(params[:client_id])
    respond_to do |format|
      if @client.present?
        @cart = Cart.new do |cart|
          cart.client_id = @client.id
          cart.user_id = current_user.id
        end
        if @cart.save
          session[:current_cart_id] = @cart.id
          format.json{render :json => @cart}
        else
          format.json{render :nothing =>true, :status => 422}
        end
      else
        format.json{render :nothing =>true, :status => 422}
      end
    end
  end
end
