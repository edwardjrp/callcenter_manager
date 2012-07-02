
class ClientsController < ApplicationController
  def create
    # "client"=>{"id"=>"", "phone"=>"8883435555", "ext"=>"34", "first_name"=>"", "last_name"=>"", "email"=>""}
    @client = Client.new(first_name: params[:client][:first_name],last_name: params[:client][:last_name],email: params[:client][:email], phones_attributes: [{number: params[:client][:phone], ext: params[:client][:ext]}])
    respond_to do |format|
      if !Phone.exists?(:number=>params[:client][:phone],:ext=>params[:client][:ext]) && @client.save
        format.json{render json: @client}
      else
        format.json{render json: @client.errors , :status => 422}
      end
    end
  end
end
