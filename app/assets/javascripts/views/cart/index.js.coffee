class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
    @model.on('change', @render, this)
    @model.on('change', @highlight, this)
  
  events: ->
    'click .remove_options_and_pricing>span.item_remove':'remove_cart_product'
    'click .remove_options_and_pricing>span.show_options':'show_options'
    'change .item>input':'update_quantity'
    'focus .item>input':'colorize'
    'blur .item>input':'normalize'
    
  
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
      
  highlight: ->
    $(@el).find('#current_carts_items, .item').effect('highlight')

    
  colorize: (event)->
    target = $(event.currentTarget)
    target.css('background-color','#F78181')

  normalize: (event)->
    target = $(event.currentTarget)
    target.css('background-color','white')
      
      
  show_options: (event)->
    target = $(event.currentTarget)
    target.parent().parent().next().toggle()
    
  update_quantity: (event)->
    target = $(event.currentTarget)
    item_to_update_cid = target.closest('.item').data('cart-product-cid')
    item_to_update = @model.get('cart_products').getByCid(item_to_update_cid)
    item_to_update.set({quantity: target.val()}, {silent: true})
    item_to_update.save()
    