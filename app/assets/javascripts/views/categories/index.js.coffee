class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  initialize: ->
    _.bindAll(this, 'get_main_products', 'get_option_products', 'group_by_options', 'get_presentation_name', 'get_flavors', 'get_sizes', 'get_valid_sizes', 'get_valid_flavors')
    @product_views = {}
    _.each @collection.models, (category) =>
      unless category.get('hidden') == true
        main_products = @get_main_products(category.get('products'))
        option_products = @get_option_products(category.get('products'))
        @product_views["#{category.get('name')}"] = new Kapiqua25.Views.ProductsIndex(collection: main_products, model: @model, category: category, sides: option_products, matchups: @create_matchups(main_products, option_products, category), flavors:@get_flavors(main_products), sizes: @get_sizes(main_products) )
  
  events: ->
    'click .nav-tabs a': 'mark_base'
  
  render: ->
    $(@el).html(@template(collection: @collection))
    _.each _.keys(@product_views), (key)=>
      $(@el).find("##{key}").html(@product_views[key].render().el)
    this
        
  mark_base: (event)->
    target= $("##{$(event.currentTarget).attr('href').replace(/#/,'')}")
    target.find("[data-bproduct='true']").trigger('click') if (target.find("[data-bproduct='true']").size() > 0 and target.find('.specialties_container').find('.btn-primary').size() == 0)
        
  get_main_products: (main_products)->
    _.filter main_products.models, (product)-> product.get('options') != 'OPTION'

  get_valid_sizes: (main_products)->
    _.map(main_products, (mproduct)-> mproduct.get('sizecode'))

  get_valid_flavors: (main_products)->
    _.map(main_products, (mproduct)-> mproduct.get('flavorcode'))

  get_option_products: (option_products)->
    _.filter option_products.models, (product)-> product.get('options') == 'OPTION'
  
  get_flavors: (products)->
    _.uniq(_.map(products, (product)-> product.get('flavorcode')))

  get_sizes: (products)->
    _.uniq(_.map(products, (product)-> product.get('sizecode')))

    
  group_by_options: (products)->
    _.groupBy products, (product) -> product.get('options')

  group_by_flavorcode: (products)->
    _.groupBy products, (product) -> product.get('flavorcode')

  
  get_presentation_name: (group_products) ->
    (_.intersection.apply(_, _.map(group_products, (product)-> product.get('productname').split(' ') ))).join(' ')    
    
  create_matchups: (products, options, category)->
    matchups = new Kapiqua25.Collections.Matchups()
    # if there are no options it should group by flavorcode
    if _.any(options) and category.get('has_options') == true and category.get('type_unit') == false
      _.each @group_by_options(products), (group, key) =>
          name = @get_presentation_name(group)
          parsed_options =  @parse_options(key,options)
          niffty_options =  @niffty_opions(key,options)
          matchups.add {name:  name, options: key, niffty_options: niffty_options, parsed_options:parsed_options, valid_sizes: @get_valid_sizes(group), valid_flavors: @get_valid_flavors(group), is_base: @get_base_matchup(group)?} if name !='' and key != 'null'
    else if _.any(options) and category.get('has_options') == true and category.get('type_unit') == true
      _.each products, (product) =>
          name = product.get('productname')
          parsed_options =  @parse_options(product.get('options'),options)
          niffty_options =  @niffty_opions(product.get('options'),options)
          matchups.add {name:  name, options: product.get('options'), niffty_options: niffty_options, parsed_options:parsed_options, valid_sizes: [ product.get('sizecode') ], valid_flavors: [ product.get('flavorcode') ], is_base: null} if name !=''
    else
      _.each @group_by_flavorcode(products), (group, key) =>
        name = @get_presentation_name(group)
        parsed_options = ''
        niffty_options = ''
        matchups.add {name:  name, options: '', niffty_options: niffty_options, parsed_options:parsed_options, valid_sizes: @get_valid_sizes(group), valid_flavors: @get_valid_flavors(group), is_base: @get_base_matchup(group)?} if name !='' and key != 'null'
    matchups
    
  get_base_matchup: (products)->
    base_product_id = _.first(products).get('category').get('base_product')
    if base_product_id?
      _.find products, (product)-> product.id == base_product_id
    
    
  parse_options: (recipe, options)->
    product_options = []
    if recipe? and _.any(recipe.split(','))
      _.each _.compact(recipe.split(',')), (recipe) ->
        product_options.push(new Option(recipe, options).toJSON())
    product_options
    
    
  niffty_opions: (recipe, options) ->
    product_options = []
    if recipe? and _.any(recipe.split(','))
      _.each _.compact(recipe.split(',')), (recipe) ->
        product_options.push(new Option(recipe, options).toString())
    to_sentence product_options
      
      
      