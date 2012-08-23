class Admin::CartsController < ApplicationController
  def index
    @search = Cart.search(params[:q])
    @carts= @search.result(:distinct => true).page(params[:page])
  end

  def show
    @cart = Cart.find(params[:id])
  end

  def assign
    case params[:destination]
    when Cart.valid_mailboxes[0]
      Cart.update_all({message_mask: 1}, {id: params[:cart_ids]})
    when Cart.valid_mailboxes[1]
      Cart.update_all({message_mask: 2}, {id: params[:cart_ids]})
    when Cart.valid_mailboxes[2]
      Cart.update_all({message_mask: 3}, {id: params[:cart_ids]})
    when Cart.valid_mailboxes[3]
      Cart.update_all({message_mask: 4}, {id: params[:cart_ids]})
    end
  end
end
