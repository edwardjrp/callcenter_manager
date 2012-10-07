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
      all_products = _.flatten(_.map(@collection.models, (category) -> category.mainProducts().models))
      coupon_products = _.map cart_coupons, (cart_coupon) ->
        _.filter all_products, (product) ->
          _.include(_.map($.parseJSON(cart_coupon.target_products), (target_product)-> target_product.product_code ), product.get('productcode'))
      coupon_products_ids = _.map _.uniq(coupon_products[0]), (coupon_product) -> coupon_product.id
      current_cart_products_ids = _.map @options.cart.get('cart_products').models, (cart_product) -> cart_product.get('product').id
      # if _.any(_.difference(coupon_products_ids, current_cart_products_ids))
      #   if confirm('¿ Desea introducir solo los productos faltantes?')
      #     console.log 'enter difference'
      #   else
      #     _.each coupon_products_ids, (cart_product_id) =>
      #       product = _.find( all_products, (product) -> product.id == cart_product_id )
      #       console.log { product_id: cart_product_id, product: product, quantity: '1', options: product.get('options'), cart_id: @options.cart, bind_id: null }
            # @options.cart.get('cart_products').add({ product_id: cart_product_id, product: product, quantity: '1', options: product.get('options'), cart_id: @options.cart, bind_id: null })

  onEditing: (data)->
    $(@el).find('.nav-tabs').find("li a[href='##{data.category.get('name')}']").trigger('click')

  render_product_views: ->
    _.each _.keys(@product_views), (key)=>
      $(@el).find("##{key}").html(@product_views[key].render().el)
        
  mark_base: (event)->
    console.log 'clicked'