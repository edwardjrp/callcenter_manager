class Kapiqua25.Routers.Categories extends Backbone.Router
  routes:
    '':'builder'
  
  initialize: ->
    _.bindAll(this, 'reloadCart')
    @categories = new Kapiqua25.Collections.Categories()
    @categories.reset($('#surface').data('categories'))
    @cart = new Kapiqua25.Models.Cart()
    @cart.set($('#cart').data('cart'))
    window.socket.on('cart_products:saved', @reloadCart)
    Backbone.pubSub = _.extend({}, Backbone.Events)


  builder: ->
    @categories_view = new Kapiqua25.Views.CategoriesIndex(collection: @categories, cart: @cart)
    @cart_view = new Kapiqua25.Views.CartIndex(model:@cart)
    $('#desk').html(@categories_view.render().el)
    $('#cart').html(@cart_view.render().el)


  reloadCart: (cart)->
     if cart?
      @cart.set(cart)
      @cart_view.render()
      $(@cart_view.render().el).find('#current_carts_items, .item').effect('highlight')