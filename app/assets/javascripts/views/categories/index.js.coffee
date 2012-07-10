class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  initialize: ->
    _.bindAll(this, 'get_main_products', 'get_option_products', 'group_by_options', 'get_presentation_name', 'get_flavors', 'get_sizes')
    @product_views = {}
    _.each @collection.models, (category) =>
      main_products = @get_main_products(category.get('products'))
      option_products = @get_option_products(category.get('products'))
      @product_views["#{category.get('name')}"] = new Kapiqua25.Views.ProductsIndex(collection: main_products, sides: option_products, matchups: @create_matchups(main_products, option_products), flavors:@get_flavors(main_products), sizes: @get_sizes(main_products) )
  
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
    
  create_matchups: (products, options)->
    matchups = new Kapiqua25.Collections.Matchups()
    _.each @group_by_options(products), (group, key) =>
        name = @get_presentation_name(group)
        matchups.add {name:  name, options: key, niffty_options: @niffty_opions(@parse_options(key,options))} if name !='' and key != 'null'
        console.log matchups
    matchups
    
  parse_options: (recipe, options)->
    product_options = []
    if _.any(recipe.split(','))
      _.each _.compact(recipe.split(',')), (code) ->
        core_match = code.match(/^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([LRW]))?/)
        if core_match?
          core_match[1] = '1' if  core_match[1]? and core_match[1] == ""
          current_quantity = core_match[1]
          current_product = _.find(options, (op)-> op.get('productcode') == core_match[2])
          current_part =  core_match[3] || ''
          product_option = {quantity: current_quantity, product: current_product, part: current_part}
          product_options.push product_option
    product_options
    
  niffty_opions: (parser_option) ->
    presentation = _.map parser_option, (option) ->
      option.quantity = '' if option.quantity == '1'
      presenter = option.quantity
      presenter += " #{option.product.get('productname')} "
      presenter += option.part.replace(/L/,'Izquierada').replace(/R/, 'Derecha').replace(/W/,'Completa')
      window.strip(presenter)
    to_sentence presentation
      
      
      