class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  initialize: ->
    @model.on('change', @render, this)
  
  render: ->
    $(@el).html(@template(model: @model))
    $(@el).find('input').restric('alpha').restric('spaces')
    this