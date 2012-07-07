
class CategoriesController < ApplicationController
  respond_to :json
  def index 
    respond_with Category.all
  end
end
