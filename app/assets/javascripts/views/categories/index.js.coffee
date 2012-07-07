class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  events: ->
      'click .nav-tabs>li': 'mark_as_selected'
  
  initialize: ->
    @collection.on('reset', @render, this)
  
  render: ->
    $(@el).html(@template(collection: @collection))
    this
    
  mark_as_selected: (event)->
    target_category_name = $(event.target).attr('href').replace(/^#/,'')
    category = _.first(@collection.where({ name : target_category_name}))
    @draw_products(category)
    
  draw_products: (category) ->
    product_view = new Kapiqua25.Views.ProductsIndex(collection: category.get('products'))
    console.log $("##{category.get('name')}")
    $(@el).find("##{category.get('name')}").html(product_view.render().el)
    this