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
  
  def current
    respond_to do |format|
      format.json{ render json: current_cart}
    end
  end
  
  def service_method
    @cart = current_cart
    @cart.service_method = params[:service_method]
    respond_to do |format|
      if @cart.save
        format.json{render :json => @cart.as_json(only: [:service_method, :store_id])}
      else
         format.json{render :nothing =>true, :status => 422}
      end
    end
  end
  
  def current_store
    @cart = Cart.find(current_cart.id)
    @store = Store.find(params[:order_target][:store_id])
    if params[:order_target][:address_id].present? && @cart.client.present?
      @address = Address.find(params[:order_target][:address_id])
      @cart.client.target_address_id = @address.id
      @cart.client.save
    end
    @cart.store = @store
    respond_to do |format|
      if @cart.save
        format.json{render json: @cart.to_json(include: [:client, :store])}
      else
        format.json{render :nothing =>true, :status => 422}
      end
    end
  end
end
