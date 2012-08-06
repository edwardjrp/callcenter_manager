
class AddressesController < ApplicationController

  def create
    @client = Client.find(params[:client_id])
    @address = @client.addresses.build(params[:address])
    respond_to do |format|
      format.json{ render json: @address.to_json(include: {street: {include: {area: {include: {city: {}}}}}})}
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
