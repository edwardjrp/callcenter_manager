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
        format.json{ render json: @phone.errors.full_messages, status: 422}
      end
    end
  end

  def destroy
   @phone = Phone.find params[:id]
    respond_to do |format|
      if @phone.destroy  
        format.js{ render nothing: true, status: 200}
      else
        format.js{ render text: @phone.errors.full_messages.to_sentence, status: 422}
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
