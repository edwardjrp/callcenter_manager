class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
    @model.on('change', @render)
  
  render: ->
    $(@el).html(@template(model: @model))
    this