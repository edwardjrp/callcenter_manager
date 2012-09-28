class Kapiqua25.Models.Matchup extends Backbone.Model
  
  defaultOptions: ()->
    if @get('recipe')? and _.any(@get('recipe').split(','))
      _.map @get('recipe').split(','), (option) =>
        new Option(option, @get('avalable_options'))

  name: ()->
    (_.intersection.apply(_, _.map(@get('products'), (product)-> product.get('productname').split(' ') ))).join(' ') 

  parsedOptions: ()->
    _.map @defaultOptions(), (option)-> option.toJSON()

  nifftyOptions: ()->
    if @defaultOptions()? then window.to_sentence(_.map @defaultOptions(), (option)-> option.toString()) else ''

  hasProduct: (product)->
    _.include(@get('products'), product[0])

  acceptedFlavors: ()->
    _.uniq(_.map(@get('products'), (product)-> product.get('flavorcode')))

  acceptedSizes: ()->
    _.uniq(_.map(@get('products'), (product)-> product.get('sizecode')))