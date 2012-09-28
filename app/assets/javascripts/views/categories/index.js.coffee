class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  initialize: ->
    @product_views = {}
    _.each @collection.models, (category) =>
      unless category.isHidden()
        @product_views["#{category.get('name')}"] = new Kapiqua25.Views.ProductsIndex(model: category, cart: @options.cart, cart_product: new Kapiqua25.Models.CartProduct() )
  
  events: ->
    'click .nav-tabs a': 'mark_base'
  
  render: ->
    $(@el).html(@template(collection: @collection))
    @render_product_views()
    this


  render_product_views: ->
    _.each _.keys(@product_views), (key)=>
      $(@el).find("##{key}").html(@product_views[key].render().el)
        
  mark_base: (event)->
    console.log 'clicked'