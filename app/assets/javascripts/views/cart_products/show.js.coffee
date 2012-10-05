class Kapiqua25.Views.CartProductsShow extends Backbone.View

  template: JST['cart_products/show']



  render: ->
    $(@el).html(@template(cart_product: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
  