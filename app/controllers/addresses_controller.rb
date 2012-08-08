
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
    @address.destroy
    respond_to do |format|
      format.js{ render nothing: true, status: 200}
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
