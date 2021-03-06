
class ClientsController < ApplicationController
  def create
    @client = Client.new(first_name: params[:client][:first_name],
                         last_name: params[:client][:last_name],
                         email: params[:client][:email],
                         idnumber: params[:client][:idnumber],
                         tax_numbers_attributes: [ params[:client][:tax_number] ],
                         phones_attributes: [ { number: params[:client][:phone], ext: params[:client][:ext] } ],
                         addresses_attributes: [ params[:client][:address] ] )
    Rails.logger.debug @client.inspect
    respond_to do |format|
      if @client.save
        format.json{render json: @client}
      else
        Rails.logger.debug @client.errors.full_messages
        format.json{render json: @client.errors.full_messages.to_sentence , :status => 422}
      end
    end
  end

  def update
    @client = Client.find params[:id]
    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.json{ respond_with_bip(@client)}
      else
        format.json{ respond_with_bip(@client)}
      end
    end
  end

  def set_last_phone
    @client = Client.find(params[:id])
    @old_last_phone = @client.last_phone
    @phone = @client.phones.find(params[:phone_id])
    @client.set_last_phone(@phone)
    respond_to do |format|
      format.json{ render json: @old_last_phone }
    end
  end

  def set_last_address
    @client = Client.find(params[:id])
    @old_last_address = @client.last_address
    @address = @client.addresses.find(params[:address_id])
    @client.set_last_address(@address)
    respond_to do |format|
      format.json{ render json: @old_last_address }
    end
  end

  def import
    @client = Client.new(params[:client])
    present_client= Client.find_by_idnumber(params[:client][:idnumber])
    respond_to do |format|
      if present_client.nil?
        if @client.save
          @client.mark_as_imported
          format.json{ render json: @client}
        else
          Rails.logger.debug @client.errors.full_messages
          format.json{render json: @client.errors.full_messages.to_sentence , :status => 422}
        end
      else
        format.json{render json: { msg: 'El cliente ya esta presente', present_client: present_client.to_json( include: { addresses: {}, phones: {}} ), client: params[:client]} , :status => 422}
      end
    end
  end


  def show
    @client = Client.includes(:carts).find(params[:id])
    @carts = @client.carts.untrashed.includes(:cart_products).completed.order('complete_on DESC').paginate(page: params[:page], per_page: 5)
  end
end
