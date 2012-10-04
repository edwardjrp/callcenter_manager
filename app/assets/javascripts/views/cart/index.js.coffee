class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
      _.bindAll(this, 'reloadCartProduct', 'removeCartProduct', 'updatePrices', 'addCartCoupon')
      window.socket.on('cart_products:updated', @reloadCartProduct)
      window.socket.on('cart_products:deleted', @removeCartProduct)
      window.socket.on('cart:priced', @updatePrices)
      window.socket.on('cart_coupon:saved', @addCartCoupon)
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

  addCartCoupon: (data)->
    if data?
      @model.get('cart_coupons').add(data)
      $(@el).find('ul#current_carts_coupons').prepend("<li id = 'cart_coupon_#{data.id}'>#{data.code}<a class='coupon_remove'><i class='icon-trash'></i></a></li>")
      $(@el).find('ul#current_carts_coupons').find("#cart_coupon_#{data.id}").effect('highlight')

  updatePrices: (data)->
    @model.set 
      net_amount: data.order_reply.netamount
      tax_amount: data.order_reply.taxamount
      tax1_amount: data.order_reply.tax1amount
      tax2_amount: data.order_reply.tax2amount
      payment_amount: data.order_reply.payment_amount
    cart_pricing = $("<div></div>")
    .append("<div class='row'><div class = 'span2'><strong>Neto</strong> RD$ #{Number(data.order_reply.netamount).toFixed(2)}</div></div>")
    .append("<div class='row'><div class = 'span2'><strong>Impuestos</strong> RD$ #{Number(data.order_reply.taxamount).toFixed(2)}</div></div>")
    .append("<div class='row'><div class = 'span2'><strong>Total</strong> RD$ #{Number(data.order_reply.payment_amount).toFixed(2)}</div></div>")
    $(@el).find('#cart_price_data').html(cart_pricing)
    for item in data.items
      $(@el).find("[data-cart-product-id='#{item.cart_product_id}']").find('.pricing').html("RD$ #{Number(item.priced_at).toFixed(2)}")

  reloadCartProduct: (data)->
    item = @model.get('cart_products').get(data.id)
    target = $(@el).find("[data-cart-product-id='#{data.id}']")
    target.find("input[name='quantity']").val(data.quantity)
    target.next().html(item.niffty_opions())
    target.effect('highlight')

  removeCartProduct: (id)->
    @model.get('cart_products')
    target = $(@el).find("[data-cart-product-id='#{id}']")
    target.remove()
    $(@el).effect('highlight')

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
    