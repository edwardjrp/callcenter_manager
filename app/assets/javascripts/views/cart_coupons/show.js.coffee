class Kapiqua25.Views.CartCouponsShow extends Backbone.View

  template: JST['cart_coupons/show']

  # initialize: ->
  #   _.bindAll(this,'updatePrices')
  #   @model.on('change', @render, this)
  #   window.socket.on('cart:priced', @updatePrices)


  render: ->
    $(@el).html(@template(cart_coupon: @model))
    this
  
  # updatePrices: (data) ->
  #   edit_data = _.find(data.items, (item) => item.cart_product_id == @model.id)
  #   @model.set({priced_at: edit_data.priced_at}) if edit_data?