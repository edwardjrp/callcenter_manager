
class HomeController < ApplicationController
  def index
    @clients = Client.find_clients(params[:client])
    respond_to do |format|
      format.json{render json: @clients}
      format.html
    end
  end
end
