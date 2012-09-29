class Kapiqua25.Models.Product extends Backbone.RelationalModel

  defaultOptions: ()->
    if @get('options')? and _.any(@get('options').split(','))
      _.map @get('options').split(','), (option) =>
        new Kapiqua25.Models.Option().set(recipe: option, products: @get('avalable_options'))

  parsedOptions: ()->
    _.map @defaultOptions(), (option)-> option.toJSON()

  nifftyOptions: ()->
    if @defaultOptions()? then window.to_sentence(_.map @defaultOptions(), (option)-> option.toString()) else ''
