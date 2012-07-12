
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
    change_state(:has_options)
  end
  
  def change_units
    change_state(:type_unit)
  end
  
  def change_multi
    change_state(:multi)
  end
  
  private
  
    def change_state(field)
      @category = Category.find(params[:id])
      @category[field] = !@category[field]
      respond_to do |format|
        if @category.save
          format.json{ render :json=>@category}
        else
          format.json{render json: @category.errors.full_messages.to_sentence , :status => 422}
        end
      end
    end
  
end
