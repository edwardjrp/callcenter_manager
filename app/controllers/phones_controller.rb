#encoding: utf-8
class PhonesController < ApplicationController
  def index
    @phones = Phone.find_phones(params[:client])
    respond_to do |format|
      format.json{render :json => @phones}
    end
  end
end
