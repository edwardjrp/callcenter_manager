class Admin::ServicesController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
  end

  def create
    flash[:success]=params[:soap_action]
    ProductsImport.perform_async
    redirect_to :back
  end

  # private
  #   def soap_actions(sent_action)
  #   end
end
