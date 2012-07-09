class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  initialize: ->
    _.bindAll(this, 'get_main_products', 'get_option_products', 'group_by_options', 'get_presentation_name', 'get_flavors', 'get_sizes')
    @product_views = {}
    _.each @collection.models, (category) =>
      main_products = @get_main_products(category.get('products'))
      option_products = @get_option_products(category.get('products'))
      @product_views["#{category.get('name')}"] = new Kapiqua25.Views.ProductsIndex(collection: main_products, sides: option_products, matchups: @create_matchups(main_products), flavors:@get_flavors(main_products), sizes: @get_sizes(main_products) )
  
  render: ->
    $(@el).html(@template(collection: @collection))
    _.each _.keys(@product_views), (key)=>
      $(@el).find("##{key}").html(@product_views[key].render().el)
    this
        
  get_main_products: (main_products)->
    man_products = _.filter main_products.models, (product)-> product.get('options') != 'OPTION'
  get_option_products: (option_products)->
    man_products = _.filter option_products.models, (product)-> product.get('options') == 'OPTION'
  
  get_flavors: (products)->
    _.uniq(_.map(products, (product)-> product.get('flavorcode')))

  get_sizes: (products)->
    _.uniq(_.map(products, (product)-> product.get('sizecode')))

    
  group_by_options: (products)->
    _.groupBy products, (product) -> product.get('options')
  
  get_presentation_name: (group_products) ->
    (_.intersection.apply(_, _.map(group_products, (product)-> product.get('productname').split(' ') ))).join(' ')    
    
  create_matchups: (products)->
    matchups = new Kapiqua25.Collections.Matchups()
    _.each @group_by_options(products), (group, key) =>
        name = @get_presentation_name(group)
        matchups.add {name:  name, options: key} if name !='' and key != 'null'
    matchups