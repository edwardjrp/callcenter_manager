class Admin::ClientsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  
  def index
    @clients= Client.page(params[:page])
  end

  def show
    @client= Client.find(params[:id])
    @carts = @client.carts.page(params[:page])
  end
end
