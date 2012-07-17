_ = require('underscore')
pg = require('pg')
util = require('util')


class CartProduct
  constructor: (@attributes)->
    throw "Wrong initialization types" unless _.isObject(@attributes)
    this['validate'] = new Validate(this)
    this['errors'] = []
    _.each _.keys(attributes), (key) =>
      this["#{key}"] = attributes["#{key}"]
    
    isValid: ()->
      @validate.presenceOf(@name)
      _.isEmpty(@errors)
        
class Validate
  constructor: (@model)->
  presenceOf: (attribute) ->
    unless @model[attribute]? 
      @model.errors.push("#{attribute} no puede estar en blanco")
    

cp = new CartProduct({last_name: 'last'})
cp2 = new CartProduct({name: 'Test', last_name: 'last'})

console.log cp.isValid
# console.log cp.name
# console.log cp.last_name