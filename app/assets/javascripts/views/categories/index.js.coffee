class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  render: ->
    $(@el).html(@template())