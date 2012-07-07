class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  render: ->
    $(@el).html(@template(collection: @collection))
    this