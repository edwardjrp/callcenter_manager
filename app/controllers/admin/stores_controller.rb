
class Admin::StoresController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  
  def index
    @stores = Store.order(:name).page(params[:page])
  end

  def new
    @store = Store.new
  end

  def create
    @store= Store.new(params[:store])
    if @store.save
      flash['success'] ="Tienda creada"
      redirect_to admin_stores_path
    else
      render action: :new 
    end
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash['success']='Tienda actualizada'
      redirect_to admin_stores_path
    else
      render action: :edit
    end
  end

  def edit
    @store = Store.find params[:id]
  end

  def show
    @store = Store.find(params[:id])
    params[:q][:productname_cont] = params[:q][:productname_cont].gsub(/"/,'&quot;') if  params[:q].present? && params[:q][:productname_cont].present? 
    @search = Product.search(params[:q])
    @products = @search.result.page(params[:page])
    flash['info'] = 'Su busqueda no produjo resultados' if @products.empty?
  end

  def destroy
    @store = Store.find params[:id]
    if @store.destroy
      flash[:success]='Tienda eliminada'
    else
      flash[:error]=@store.errors.full_message.to_sentence
    end
    redirect_to admin_stores_path
  end
end
