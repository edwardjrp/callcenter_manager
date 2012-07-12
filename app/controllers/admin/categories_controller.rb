
class Admin::CategoriesController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    @categories = Category.order('name ASC').page(params[:page])
  end
  
  def set_base
    @category = Category.find(params[:id])
    @product = @category.products.are_main.find(params[:product_id])
    @category.base_product= @product.id
    respond_to do |format|
      if  @category.save
        format.json{ render :json=>@product.to_json(include:{category:{only:[:name]}})}
      else
        format.json{render json: @category.errors.full_messages.to_sentence , :status => 422}
      end
    end
  end
  
  def change_options
    @category = Category.find(params[:id])
    @category.has_options = !@category.has_options
    respond_to do |format|
      if @category.save
        format.json{ render :json=>@category}
      else
        format.json{render json: @category.errors.full_messages.to_sentence , :status => 422}
      end
    end
  end
  
  def change_units
    @category = Category.find(params[:id])
    @category.type_unit = !@category.type_unit
    respond_to do |format|
      if @category.save
        format.json{ render :json=>@category}
      else
        format.json{render json: @category.errors.full_messages.to_sentence , :status => 422}
      end
    end
  end
  
  def change_multi
    @category = Category.find(params[:id])
    @category.multi = !@category.multi
    respond_to do |format|
      if @category.save
        format.json{ render :json=>@category}
      else
        format.json{render json: @category.errors.full_messages.to_sentence , :status => 422}
      end
    end
  end
  
end
