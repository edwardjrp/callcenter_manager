class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
      _.bindAll(this, 'reloadCartProduct')
      window.socket.on('cart_products:updated', @reloadCartProduct)
  #   @model.on('change', @render, this)
  #   @model.on('change', @highlight, this)
  
  events: ->
    'click .remove_options_and_pricing>span.item_remove':'remove_cart_product'
    'click .remove_options_and_pricing>span.show_options':'show_options'
    'click .remove_options_and_pricing>span.edit_options':'edit_options'
    'change .item>input':'update_quantity'
    'focus .item>input':'colorize'
    'blur .item>input':'normalize'
    
  
  render: ->
    $(@el).html(@template(model: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this


  reloadCartProduct: (data)->
    item = @model.get('cart_products').get(data.id)
    item_cid = @model.get('cart_products').get(data.id).cid
    target = $(@el).find("[data-cart-product-cid='#{item_cid}']")
    target.find("input[name='quantity']").val(data.quantity)
    target.next().html(item.niffty_opions())
    target.effect('highlight')

  edit_options: (event)->
    target = $(event.currentTarget)
    item_to_edit_cid = target.closest('.item').data('cart-product-cid')
    item_to_edit = @model.get('cart_products').getByCid(item_to_edit_cid)
    product_for_edit = item_to_edit.get('product')
    category_for_edit = product_for_edit.get('category')
    Backbone.pubSub.trigger('editing', { cart_product: item_to_edit, product: product_for_edit, category: category_for_edit } )

  remove_cart_product: (event)->
    target = $(event.currentTarget)
    if confirm('¿Remover producto de la orden?')
      item_to_remove_cid = target.closest('.item').data('cart-product-cid')
      item_to_remove = @model.get('cart_products').getByCid(item_to_remove_cid)
      item_to_remove.destroy()

    
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
    