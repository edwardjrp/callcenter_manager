
class ClientsController < ApplicationController
  def phone
    @phone = Phone.where(number: params[:client][:phone], ext: params[:client][:ext]).first
    @client = @phone.client
    respond_to do |format|
      format.json{render json: @client}
      format.html
    end
  end
end
