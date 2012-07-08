class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  events: ->
      'click .nav-tabs>li': 'mark_as_selected'
  
  initialize: ->
    _.bindAll(this, 'mark_as_selected', 'draw_products', 'get_main_products', 'get_option_products', 'group_by_options', 'get_presentation_name')
    @collection.on('reset', @render, this)
  
  render: ->
    $(@el).html(@template(collection: @collection))
    this
    
  mark_as_selected: (event)->
    target_category_name = $(event.target).attr('href').replace(/^#/,'')
    category = _.first(@collection.where({ name : target_category_name}))
    @draw_products(category)
    
  draw_products: (category) ->
    main_products = @get_main_products(category.get('products'))
    option_products = @get_option_products(category.get('products'))
    product_view = new Kapiqua25.Views.ProductsIndex(collection: main_products, sides: option_products, matchups: @create_matchups(main_products))
    $(@el).find("##{category.get('name')}").html(product_view.render().el)
    this
    
  get_main_products: (main_products)->
    man_products = _.filter main_products.models, (product)-> product.get('options') != 'OPTION'
  get_option_products: (option_products)->
    man_products = _.filter option_products.models, (product)-> product.get('options') == 'OPTION'
    
    
  group_by_options: (products)->
    _.groupBy products, (product) -> product.get('options')
  
  get_presentation_name: (group_products) ->
    (_.intersection.apply(_, _.map(group_products, (product)-> product.get('productname').split(' ') ))).join(' ')    
    
  create_matchups: (products)->
    matchups = []
    _.each @group_by_options(products), (group, key) =>
        matchup = {name:  @get_presentation_name(group), options: key}
        matchups.push matchup
    matchups