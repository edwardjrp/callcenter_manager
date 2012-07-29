
class Admin::StoresController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  
  def index
    @stores = Store.order(:id).page(params[:page])
  end

  def new
  end

  def update
    @store = Store.find(params[:id])
    respond_to  do |format|
      if @store.update_attributes(params[:store])
        format.json {render json: @store }
      else
        format.json {render json: [@store.errors.full_messages.to_sentence], :status=>422 }
      end
    end
  end

  def show
  end
end
