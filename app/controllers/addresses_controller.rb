class AddressesController < ApplicationController

  def create
    @client = Client.find(params[:client_id])
    @address = @client.addresses.build(params[:address])
    respond_to do |format|
      if @address.save
        format.json{ render json: @address.to_json(include: {street: {include: {area: {include: {city: {}}}}}})}
      else
        format.json{ render json: [@address.errors.full_messages], status: 422}
      end
    end
  end

  def destroy
    @address = Address.find params[:id]
    respond_to do |format|
      if @address.destroy  
        format.js{ render nothing: true, status: 200}
      else
        format.js{ render nothing: true, status: 422}
      end
    end
  end

  def update
    @address = Address.find(params[:id])
    respond_to do |format|
      if @address.update_attributes(params[:address])
        format.json{ render json: @address.to_json(include: {street: { include: {area: {include: {city: {}}}}}})}
      else
        format.json{ render json: @address.errors.full_messages.to_json, status: 422}
      end
    end
  end

  def areas
    @areas = Area.find_area(params)
    respond_to do |format|
      format.json{ render json: @areas}
    end
  end
  
  def streets
    @streets = Street.find_street(params)
    respond_to do |format|
      format.json{ render json: @streets}
    end
  end
end
