class Admin::StoreProductsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin, :supervisor], root_path)}
  
  def create
    @store_product = StoreProduct.new(params[:store_product])
    respond_to do |format|
      if @store_product.save
        format.json{ render json: @store_product  }
      else
        format.json{ render json: @store_product.errors.full_messages.to_sentence}
      end
    end
  end


  def assign_all
    @store = StoreProduct.create_collection(params[:store_id])
    if @store.present?
      flash['success'] = 'Todo los productos para esta tienda han sido Habilitados'
    else
      flash['error'] = 'No se pudo asignar todos los productos para esta tienda'
    end
    redirect_to [:admin, @store] || admin_stores_path
  end
  
  def update
    @store_product = StoreProduct.find(params[:id])
    @store_product.available = !@store_product.available
    respond_to do |format|
      if @store_product.save
        format.json{ render json: @store_product  }
      else
        format.json{ render json: @store_product.errors.full_messages.to_sentence}
      end
    end
  end
end
