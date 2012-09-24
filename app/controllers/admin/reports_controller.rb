#encoding:  utf-8
class Admin::ReportsController < ApplicationController
    before_filter {|c| c.accessible_by([:admin], root_path)}

    def index      
      @search = Cart.completed.search(params[:q])
      @carts= @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 30)
      respond_to do |format|
        format.html
        format.csv { render text: @search.result(:distinct => true).detailed_report }
      end
    end

    # def create 
    #   @search = Cart.completed.search(params[:q])
    #   @carts= @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 30)
    #   flash['success'] = params
    #   redirect_to :back
    # end
end
