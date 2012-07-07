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
    category = _.first(@collection.where({ name : 'Bread'}))
    @get_product_for(category)
    
  get_product_for: (category) ->
    products_url = "#{category.url()}/products"