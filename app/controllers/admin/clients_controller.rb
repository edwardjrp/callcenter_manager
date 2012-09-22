class Admin::ClientsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  
  def index
    @search = Client.search(params[:q])
    @clients= @search.result(:distinct => true).order('created_at DESC').page(params[:page])
  end

  def show
    @client= Client.find(params[:id])
    @carts = @client.carts.page(params[:page])
  end

  def olo
  end

  def update
    @client = Client.find(params[:id])
    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.json{ render json: @client}
      else
        format.json{ render json: @client.errors.full_messages.to_sentence, status: 422}
      end
    end
  end

  def merge
    @search = Client.search(params[:q])
    @clients= @search.result(:distinct => true).limit(4)
    respond_to do |format|
      format.json{ render json: @clients.to_json( include: { addresses: { include: { street: { include: { area: { include: { city: {}}}}}}}, phones: {} } )}
      format.html
    end
  end

  def destroy
    @client = Client.find(params[:id])
    if @client.destroy
      flash[:success]='Cliente Eliminado.'
    else
      flash[:error]=@client.errors.full_messages.to_sentence
    end
    redirect_to admin_clients_path
  end

  def merge_clients
    @client = Client.find(params[:merged_client][:id])
    respond_to do |format|
      if @client.merge(params[:merged_client], params[:source_client_id])
        flash[:success]='Clientes fusionados correctamente.'
        format.json{render json: @client}
      else
        flash[:error]="Un error ha impedido completar el proceso"
        format.json{render json: @client.errors.full_messages.to_sentence, status: 422}
      end
    end
  end
end
