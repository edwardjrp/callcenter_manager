class Kapiqua25.Models.Category extends Backbone.RelationalModel
  relations:[
      type: Backbone.HasMany
      key: 'products'
      relatedModel: 'Kapiqua25.Models.Product'
      collectionType: 'Kapiqua25.Collections.Products'
      reverseRelation:
        key: 'category'
        includeInJSON: 'id'
    ]

  isHidden: ()->
    @get('hidden')

  hasOptions: ()->
    @get('has_options')

  isMulti: ()->
    @get('multi')

  hasSides: ()->
    @get('has_sides')

  typeUnit: ()->
    @get('type_unit')

  configurableType: ()->
    if @hasOptions()
      if @typeUnit()
        'with_units'
      else
        if @isMulti() and @hasSides()
          'multi_and_sides'
        else
          'amount'
    else
      'No'

  optionProducts: ()->
    @get('products').where({options: 'OPTION'})

  mainProducts: ()->
    new Kapiqua25.Collections.Products(_.filter(@get('products').models, (option)-> option.get('options') != 'OPTION'))

  availableSizes: ()->
    _.uniq(@mainProducts().pluck('sizecode'))

  availableFlavors: ()->
    _.uniq(@mainProducts().pluck('flavorcode'))

  baseProduct: ()->
    @mainProducts().where( {id: @get('base_product')} )

  productsByOptions: ()->
    _.groupBy( @mainProducts().models, (product)-> product.get('options') )

  productsByFlavor: ()->
    _.groupBy( @mainProducts().models, (product)-> product.get('flavorcode') )

  productsBySize: ()->
    _.groupBy( @mainProducts().models, (product)-> product.get('sizecode') )

  matchups: ()->
    @category_matchups ?= @load_matchup()


  load_matchup: ()->
    category_matchups = new Kapiqua25.Collections.Matchups()
    if @hasOptions() and not @typeUnit()
      for recipe in _.keys(@productsByOptions())
        category_matchups.add new Kapiqua25.Models.Matchup().set(recipe: recipe, products: @productsByOptions()[recipe], available_options: @optionProducts() )

    else if @hasOptions() and @typeUnit()
      for product in @mainProducts().models
        category_matchups.add new Kapiqua25.Models.Matchup().set(recipe: product.get('options'), products: [product], available_options: @optionProducts() )

    else if not @hasOptions()
      for recipe in _.keys(@productsByFlavor())
        category_matchups.add new Kapiqua25.Models.Matchup().set(recipe: recipe, products: @productsByFlavor()[recipe], available_options: @optionProducts() )
    category_matchups


Kapiqua25.Models.Category.setup()