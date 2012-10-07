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
         @cart.reset_for_new_client!
         @cart.save
         format.json{render :json => @cart.as_json(only: [:service_method, :store_id], include: [client: {only: [:id, :first_name, :last_name]}])}
      else
        format.json{render :nothing =>true, :status => 422}
      end
    end
  end
  
  def current
    respond_to do |format|
      format.json{ render json: current_cart.to_json(include: [:store])}
    end
  end

  def completed
    @cart = Cart.find(params[:id])
    flash['success'] = "Orden : #{params[:store_order_id]} completada"
    if @cart
      cart_reset
      respond_to do | format|
        format.json{ render :nothing =>true, :status => 200 }
      end
    end
  end
  
  
  def discount
    @cart = current_cart
    #MOVE TO MODEL
    respond_to do |format|
      if params[:discount]
        user = User.authenticate(params[:discount][:auth_user], params[:discount][:auth_pass])
        discount_amount = params[:discount][:order_discount_amount] || 0
        discount_amount = 0 if discount_amount.blank?
        tax_discount = params[:discount][:tax_discount_amount] || 0
        tax_discount = 0 if params[:discount][:discount_tax] != 'on'
        begin
          new_current_payment_amount= current_cart.payment_amount - (Float(tax_discount) + Float(discount_amount))
          new_current_payment_amount= current_cart.payment_amount if new_current_payment_amount < 0
          if user && user.is?(:admin)
            @cart.discount_auth_id= user.id
            @cart.discount = discount_amount
            @cart.payment_amount = new_current_payment_amount
            @cart.save!
            format.json{render json: {authorized_by: user.to_json(only: [:first_name, :last_name]), new_payment_amount: new_current_payment_amount}}
          else
            format.json{render json: {error: 'NO se autorizo el descuento'}, :status => 422}      
          end
        rescue
            format.json{render json: {error: 'El descuento no se puede aplicar'}, :status => 422}      
        end
      else
        format.json{render json: {error: 'Parametros incompletos'}, :status => 422}      
      end
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
