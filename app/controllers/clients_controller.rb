
class ClientsController < ApplicationController
  def create
    @client = Client.new(first_name: params[:client][:first_name],
                         last_name: params[:client][:last_name],
                         email: params[:client][:email], 
                         phones_attributes: [{number: params[:client][:phone], ext: params[:client][:ext]}],
                         addresses_attributes: [params[:client][:address]])
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
        format.json{render json: {msg: 'El cliente ya esta presente', present_client: present_client.to_json( include: [ addresses: {}, phones: {}] ), client: @client} , :status => 422}
      end
    end
  end


  def show
    @client = Client.find(params[:id])
    @carts = @client.carts.page(params[:page])
  end
end
