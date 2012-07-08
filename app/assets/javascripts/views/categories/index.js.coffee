class Kapiqua25.Views.CategoriesIndex extends Backbone.View

  template: JST['categories/index']
  
  events: ->
      'click .nav-tabs>li': 'mark_as_selected'
  
  initialize: ->
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
    # console.log main_products
    product_view = new Kapiqua25.Views.ProductsIndex(collection: main_products, sides: option_products)
    $(@el).find("##{category.get('name')}").html(product_view.render().el)
    this
    
  get_main_products: (main_products)->
    man_products = _.filter main_products.models, (product)-> product.get('options') != 'OPTION'
  get_option_products: (option_products)->
    man_products = _.filter option_products.models, (product)-> product.get('options') == 'OPTION'