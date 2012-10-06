class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
      _.bindAll(this,'updatePrices', 'removeCartProduct', 'addCartCoupon', 'removeCartCoupon', 'remove_coupon', 'addCartProduct')
      # window.socket.on('cart_products:deleted', @removeCartProduct)
      window.socket.on('cart:priced', @updatePrices)
      window.socket.on('cart_coupon:saved', @addCartCoupon)
      window.socket.on('cart_coupons:deleted', @removeCartCoupon)
      @model.get('cart_products').on('add', @addCartProduct)
      @model.get('cart_products').on('remove', @removeCartProduct)
      @model.on('change', @render, this)
  #   @model.on('change', @render, this)
  #   @model.on('change', @highlight, this)
  
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
    this


  addCartProduct: (cart_coupon) ->
    view = new Kapiqua25.Views.CartProductsShow(model: cart_coupon)
    @$('#current_carts_items').append(view.render().el)

  addCartCoupon: (data)->
    if data?
      @model.get('cart_coupons').add(data)
      $(@el).find('ul#current_carts_coupons').prepend("<li id = 'cart_coupon_#{data.id}'>#{data.code}<a class='coupon_remove'  data-cart-coupon-id='data.id'  ><i class='icon-trash'></i></a></li>")
      $(@el).find('ul#current_carts_coupons').find("#cart_coupon_#{data.id}").effect('highlight')

  removeCartCoupon: (data)->
    if data?
      $(@el).find('ul#current_carts_coupons').find("#cart_coupon_#{data}").remove()
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
    # cart_pricing = $("<div></div>")
    # .append("<div class='row'><div class = 'span2'><strong>Neto</strong> RD$ #{Number(data.order_reply.netamount).toFixed(2)}</div></div>")
    # .append("<div class='row'><div class = 'span2'><strong>Impuestos</strong> RD$ #{Number(data.order_reply.taxamount).toFixed(2)}</div></div>")
    # .append("<div class='row'><div class = 'span2'><strong>Total</strong> RD$ #{Number(data.order_reply.payment_amount).toFixed(2)}</div></div>")
    # $(@el).find('#cart_price_data').html(cart_pricing)
    # for item in data.items
    #   $(@el).find("[data-cart-product-id='#{item.cart_product_id}']").find('.pricing').html("RD$ #{Number(item.priced_at).toFixed(2)}")

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
    