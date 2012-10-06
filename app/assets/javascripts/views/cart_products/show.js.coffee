class Kapiqua25.Views.CartProductsShow extends Backbone.View

  template: JST['cart_products/show']

  initialize: ->
    @model.on('change', @render, this)



  render: ->
    $(@el).html(@template(cart_product: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
  