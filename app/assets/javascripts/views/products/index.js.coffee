class Kapiqua25.Views.ProductsIndex extends Backbone.View

  template: JST['products/index']
  
  events: ->
    'click .specialties':'select_specialty'
  
  render: ->
    $(@el).html(@template(collection: @collection, options:@options))
    this
    
  select_specialty: (event)->
    event.preventDefault()
    console.log $(event.target)
  