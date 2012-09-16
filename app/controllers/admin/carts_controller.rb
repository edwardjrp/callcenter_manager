class Admin::CartsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    @search = Cart.completed.search(params[:q])
    @carts= @search.result(:distinct => true).paginate(:page => params[:page], :per_page => 30)
    @carts_csv = @search.result(:distinct => true)
    respond_to do |format|
      format.csv { send_data @carts_csv.detailed_report}
      format.html
    end
  end

  def show
    @cart = Cart.find(params[:id])
  end

  def assign
    respond_to do |format|
      case params[:destination]
      when Cart.valid_mailboxes[0]
        if Cart.update_all({message_mask: 1}, {id: params[:cart_ids]})
          format.json{ render json: Cart.find(params[:cart_ids])}
        else
          format.json{ render nothing: true, status: 422}
        end
      when Cart.valid_mailboxes[1]
        if Cart.update_all({message_mask: 2}, {id: params[:cart_ids]})
          format.json{ render json: Cart.find(params[:cart_ids])}
        else
          format.json{ render nothing: true, status: 422}
        end
      when Cart.valid_mailboxes[2]
        if Cart.update_all({message_mask: 4}, {id: params[:cart_ids]})
          format.json{ render json: Cart.find(params[:cart_ids])}
        else
          format.json{ render nothing: true, status: 422}
        end
      when Cart.valid_mailboxes[3]
        if Cart.update_all({message_mask: 8}, {id: params[:cart_ids]})
          format.json{ render json: Cart.find(params[:cart_ids])}
        else
          format.json{ render nothing: true, status: 422}
        end
      end
    end
  end
end
