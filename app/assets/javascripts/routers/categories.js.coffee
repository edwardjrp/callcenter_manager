class Kapiqua25.Routers.Categories extends Backbone.Router
  routes:
    '':'builder'
  
  initialize: ->
    @categories = new Kapiqua25.Collections.Categories()
    @categories.reset($('#surface').data('categories'))
  
  builder: ->
    categories_view = new Kapiqua25.Views.CategoriesIndex(collection: @categories)
    $('#desk').html(categories_view.render().el)