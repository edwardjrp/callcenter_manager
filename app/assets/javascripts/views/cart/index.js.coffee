class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
      _.bindAll(this,'updatePrices', 'removeCartProduct','remoteAddCartCoupon', 'addCartCoupon', 'removeCartCoupon', 'remove_coupon', 'addCartProduct','render')
      window.socket.on('cart:priced', @updatePrices)
      window.socket.on('cart_coupon:saved', @remoteAddCartCoupon)
      window.socket.on('cart:empty', @render)
      @model.get('cart_products').on('add', @addCartProduct)
      @model.get('cart_products').on('remove', @removeCartProduct)
      @model.get('cart_coupons').on('add', @addCartCoupon)
      @model.get('cart_coupons').on('remove', @removeCartCoupon)
      @model.on('change', @render, this)
  
  
  events: ->
    'click .remove_options_and_pricing>span.item_remove':'remove_cart_product'
    'click .remove_options_and_pricing>span.show_options':'show_options'
    'click .remove_options_and_pricing>span.edit_options':'edit_options'
    'click ul#current_carts_coupons .coupon_remove' : 'remove_coupon'
    'change .item>input':'update_quantity'
    'focus .item>input':'colorize'
    'blur .item>input':'normalize'
    
  
  render: ->
    $(@el).html(@template(cart: @model))
    @model.get('cart_products').each(@addCartProduct)
    @model.get('cart_coupons').each(@addCartCoupon)
    $(@el).find('input').restric('alpha').restric('spaces')
    this


  addCartProduct: (cart_product) ->
    unless _.isUnidefined
      view = new Kapiqua25.Views.CartProductsShow(model: cart_product)
      @$('#current_carts_items').append(view.render().el)

  remoteAddCartCoupon: (cart_coupon) ->
    if cart_coupon?
      @model.get('cart_coupons').add(cart_coupon)

  addCartCoupon: (cart_coupon)->
    view = new Kapiqua25.Views.CartCouponsShow(model: cart_coupon)
    @$('#current_carts_coupons').append(view.render().el)    

  removeCartCoupon: (cart_coupon)->
    $(@el).find('ul#current_carts_coupons').find("#cart_coupon_#{cart_coupon.id}").remove()
    $(@el).effect('highlight')

  remove_coupon: (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    if confirm('Desea remover el cupón')
      cart_coupon_to_remove = @model.get('cart_coupons').get(target.data('cart-coupon-id'))
      cart_coupon_to_remove.destroy()


  updatePrices: (data)->
    @model.set 
      net_amount: data.order_reply.netamount
      tax_amount: data.order_reply.taxamount
      tax1_amount: data.order_reply.tax1amount
      tax2_amount: data.order_reply.tax2amount
      payment_amount: data.order_reply.payment_amount

  remove_cart_product: (event)->
    target = $(event.currentTarget)
    if confirm('¿Remover producto de la orden?')
      item_to_remove_id = target.closest('.item').data('cart-product-id')
      @model.get('cart_products').get(item_to_remove_id).destroy()

  removeCartProduct: (cart_product)->
    target = $(@el).find("[data-cart-product-id='#{cart_product.id}']")
    target.remove()
    $(@el).effect('highlight')

  edit_options: (event)->
    target = $(event.currentTarget)
    item_to_edit_cid = target.closest('.item').data('cart-product-cid')
    item_to_edit = @model.get('cart_products').getByCid(item_to_edit_cid)
    product_for_edit = item_to_edit.get('product')
    category_for_edit = product_for_edit.get('category')
    # send the cart_product id instead of the cart product it self
    Backbone.pubSub.trigger('editing', { cart_product: item_to_edit, product: product_for_edit, category: category_for_edit } )
    
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
    item_to_update_id = target.closest('.item').data('cart-product-id')
    @model.get('cart_products').get(item_to_update_id).set({quantity: target.val()}, {silent: true}).set({quantity: target.val()}).save()
    