class Admin::ServicesController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def import_products
    @product_import_log = ImportLog.products_import.includes(:import_events).order('created_at DESC').first
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
