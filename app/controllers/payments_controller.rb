class PaymentsController < ApplicationController
  before_filter :placeable

  def index
    @cart = current_cart
  end

  private

    def placeable
      @cart = current_cart
      @cart.reload
      if @cart.completed?
        cart_reset
      elsif  !@cart.placeable?
        flash['alert']= @cart.errors.full_messages.to_sentence
        redirect_to builder_path
      end
    end
end
