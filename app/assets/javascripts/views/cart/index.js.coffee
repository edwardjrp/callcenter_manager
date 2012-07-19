class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
    @model.on('change', @render, this)
  
  events: ->
    'click .remove_and_pricing>span':'remove_cart_product'
  
  render: ->
    $(@el).html(@template(model: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this
    
  remove_cart_product: (event)->
    target = $(event.currentTarget)
    if confirm('¿Remover producto de la orden?')
      item_to_remove_cid = target.closest('.item').data('cart-product-cid')
      item_to_remove = @model.get('cart_products').getByCid(item_to_remove_cid)
      item_to_remove.destroy()