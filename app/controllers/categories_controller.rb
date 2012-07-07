
class CategoriesController < ApplicationController
  respond_to :json
  def index 
    @categories = Category.all
    respond_to do |format|
     format.json{@category}
    end
  end
end
