#encoding: utf-8
class PhonesController < ApplicationController
  def index
    @phones = Phone.find_phones(params[:client])
    respond_to do |format|
      format.json{render :json => @phones}
    end
  end


  def create
    @client = Client.find params[:client_id]
    @phone = @client.phones.build(params[:phone])
    respond_to do |format|
      if @phone.save
        format.json{ render json: @phone}
      else
        format.json{ render json: @phone.errors.full_messages}
      end
    end
  end
  
  def clients
    @phone = Phone.find_phones(params[:client]).first
    @client = @phone.client
    respond_to do |format|
      format.json{render json: (@client || [])}
    end
  end
end
