#encoding: utf-8
class CartsController < ApplicationController
  def create
    @client = Client.find_by_id(params[:client_id])
    respond_to do |format|
      if @client.present?
         @cart  = @client.carts.incomplete.latest.first || current_cart
         session[:current_cart_id] = @cart.id unless @cart.id == current_cart.id
         @cart.user = current_user unless @cart.user == current_user
         @cart.client = @client unless @cart.client == @client
         @cart.save
         format.json{render :json => @cart.as_json(only: [:service_method, :store_id], include: [client: {only: [:first_name, :last_name]}])}
      else
        format.json{render :nothing =>true, :status => 422}
      end
    end
  end
end
