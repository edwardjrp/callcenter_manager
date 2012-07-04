
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
        format.json{render json: @client.errors.full_messages.to_sentence , :status => 422}
      end
    end
  end
end
