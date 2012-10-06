class Kapiqua25.Views.CartProductsShow extends Backbone.View

  template: JST['cart_products/show']

  initialize: ->
    _.bindAll(this,'updatePrices')
    @model.on('change', @render, this)
    window.socket.on('cart:priced', @updatePrices)




  render: ->
    $(@el).html(@template(cart_product: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
  
  updatePrices: (data) ->
    edit_data = _.find(data.items, (item) => item.cart_product_id == @model.id)
    console.log edit_data
    @model.set({priced_at: edit_data.priced_at})