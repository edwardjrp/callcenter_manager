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

  optionProducts: ()->
    @get('products').where({options: 'OPTION'})

  mainProducts: ()->
    new Kapiqua25.Collections.Products(_.filter(@get('products').models, (option)-> option.get('options') != 'OPTION'))

  availableSizes: ()->
    _.uniq(@mainProducts().pluck('sizecode'))

  availableFlavors: ()->
    _.uniq(@mainProducts().pluck('flavorcode'))

  base_product: ()->
    @mainProducts().where( {id: @get('base_product')} )

  productsByOptions: ()->
    _.groupBy( @mainProducts().models, (product)-> product.get('options') )

  productsByFlavor: ()->
    _.groupBy( @mainProducts().models, (product)-> product.get('flavorcode') )

  productsBySize: ()->
    _.groupBy( @mainProducts().models, (product)-> product.get('sizecode') )

  matchups: ()->
    if @hasOptions()
      for recipe in @productsByOptions()
        conosle.log recipe


Kapiqua25.Models.Category.setup()