class Kapiqua25.Routers.Categories extends Backbone.Router
  routes:
    '':'builder'
  
  initialize: ->
    @categories = new Kapiqua25.Collections.Categories()
    @categories.reset($('#surface').data('categories'))
    @cart = new Kapiqua25.Models.Cart()
    @cart.set($('#cart').data('cart'))
  
  builder: ->
    categories_view = new Kapiqua25.Views.CategoriesIndex(collection: @categories, cart: @cart)
    cart_view = new Kapiqua25.Views.CartIndex(model:@cart)
    $('#desk').html(categories_view.render().el)
    $('#cart').html(cart_view.render().el)