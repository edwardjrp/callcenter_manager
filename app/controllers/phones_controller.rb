#encoding: utf-8
class PhonesController < ApplicationController
  def index
    @phones = Phone.find_phones(params[:client])
    respond_to do |format|
      format.json{render :json => @phones}
    end
  end
  
  def clients
    @phone = Phone.find_phones(params[:client]).first
    @client = @phone.client
    respond_to do |format|
      format.json{render json: @client}
      format.html
    end
  end
end
