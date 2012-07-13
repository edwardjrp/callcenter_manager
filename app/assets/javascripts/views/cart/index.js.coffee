class Kapiqua25.Views.CartIndex extends Backbone.View

  template: JST['cart/index']
  
  render: ->
    $(@el).html(@template())
    this