# encoding: utf-8
class Admin::CartsController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    @search = Cart.order('created_at DESC').search(params[:q])
    @carts_recents  = @search.result(:distinct => true).recents.paginate(:page => params[:page_recents], :per_page => 30)
    @carts_archived  = @search.result(:distinct => true).archived.paginate(:page => params[:page_archived], :per_page => 30)
    @carts_trashed = @search.result(:distinct => true).trashed.paginate(:page => params[:page_trashed], :per_page => 30)
    @carts_criticals  = @search.result(:distinct => true).criticals.paginate(:page => params[:page_criticals], :per_page => 30)
    flash['alert'] = 'No se ha encontrado ningún récord que coincida con los criterios de búsqueda' if @search.result(:distinct => true).count.zero? && params[:q].present?
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
      format.html{ redirect_to :back }
    end
  end
end
