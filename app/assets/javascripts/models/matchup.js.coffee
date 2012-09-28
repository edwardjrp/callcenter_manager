class Kapiqua25.Models.Matchup extends Backbone.Model
  initialize: (recipe, category) ->
    @recipe = recipe
    @products = category.get('products')
    @option_groups = category.options()
    @options = @load_options()


  load_options: ()->
    if @recipe and _.any(@recipe.split(','))
      _.map @recipe.split(','), (rec)->
        new Option(rec, @option_groups)

  name: ()->
    (_.intersection.apply(_, _.map(@option_groups, (product)-> product.get('productname').split(' ') ))).join(' ') 

  parsedOptions: ()->
    _.map @options, (option)-> option.toJSON()

  nifftyOptions: ()->
    _.map @options, (option)-> option.toString()