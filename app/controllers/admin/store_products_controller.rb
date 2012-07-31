class Admin::StoreProductsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  
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
