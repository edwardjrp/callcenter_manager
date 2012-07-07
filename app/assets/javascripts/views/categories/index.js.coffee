class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  initialize: ->
    @collection.on('reset', @render, this)
  
  render: ->
    $(@el).html(@template(collection: @collection))
    this