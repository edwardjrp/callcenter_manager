
class Admin::StoresController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  
  def index
    @stores = Store.order(:id).page(params[:page])
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
    @products = Product.page(params[:page])
  end
end
