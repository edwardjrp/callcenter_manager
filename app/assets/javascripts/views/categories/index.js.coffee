class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  initialize: ->
    window.socket.on('cart:coupons:autocomplete', @couponsComplete, this)
    @product_views = {}
    Backbone.pubSub.on('editing', @onEditing, this)
    _.each @collection.models, (category) =>
      unless category.isHidden()
        @product_views["#{category.get('name')}"] = new Kapiqua25.Views.ProductsIndex(model: category, cart: @options.cart, cart_product: new Kapiqua25.Models.CartProduct() )
  
  events: ->
    'click .nav-tabs a': 'mark_base'
  
  render: ->
    $(@el).html(@template(collection: @collection))
    @render_product_views()
    this

  couponsComplete: (cart_coupons)=>
    if cart_coupons?
      current_cart_products_codes = _.map @options.cart.get('cart_products').models, (cart_product) -> cart_product.get('product').get('productcode')
      coupon_products = $.parseJSON(cart_coupons.target_products)
      coupon_products_codes = _.map coupon_products, (coupon_product) -> coupon_product.product_code
      cart_missing_products_codes = _.difference(coupon_products_codes, current_cart_products_codes)
      console.log "adding "
      console.log coupon_products
      if _.any(cart_missing_products_codes)
        if (cart_missing_products_codes.length < coupon_products_codes.length) and confirm('¿ Desea introducir solo los productos faltantes ?')
          cart_missing_products = _.filter coupon_products, (cart_coupon) -> _.include(cart_missing_products_codes,cart_coupon.product_code)
          window.socket.emit 'cart_products:add_collection', { coupon_products: cart_missing_products, cart_id: @options.cart.id }
        else
          window.socket.emit 'cart_products:add_collection', { coupon_products: coupon_products, cart_id: @options.cart.id }
      else
        if _.filter(@options.cart.get('cart_coupons').models, (coupon) -> coupon.get('code') == cart_coupons.code).length > 1
          if confirm('¿ El cupón ya esta presente, desea reintroducir los productos ?')
            window.socket.emit 'cart_products:add_collection', { coupon_products: coupon_products, cart_id: @options.cart.id }       
        else
          window.socket.emit 'cart_products:add_collection', { coupon_products: coupon_products, cart_id: @options.cart.id }       


  onEditing: (data)->
    $(@el).find('.nav-tabs').find("li a[href='##{data.category.get('name')}']").trigger('click')

  render_product_views: ->
    _.each _.keys(@product_views), (key)=>
      $(@el).find("##{key}").html(@product_views[key].render().el)
        
  mark_base: (event)->
    console.log 'clicked'