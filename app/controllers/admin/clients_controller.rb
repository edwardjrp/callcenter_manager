class Admin::ClientsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  
  def index
    @search = Client.search(params[:q])
    @clients= @search.result.page(params[:page])
  end

  def show
    @client= Client.find(params[:id])
    @carts = @client.carts.page(params[:page])
  end

  def olo
  end

  def merge
    @search = Client.search(params[:q])
    @clients= @search.result.limit(4)
    respond_to do |format|
      format.json{ render json: @clients.to_json( include: { addresses: {}, phones: {} } )}
      format.html
    end
  end
end
