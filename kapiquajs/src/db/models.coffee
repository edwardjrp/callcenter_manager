_ = require('underscore')
pg = require('pg')
util = require('util')


class CartProduct
  constructor: (@attributes)->
    throw "Wrong initialization types" unless _.isObject(@attributes)
    _.each _.keys(attributes), (key) =>
      this["#{key}"] = attributes["#{key}"]
        
        
# class Validator
#   presenceOf: (attribute, model) ->
#     "#{attribute} no puede estar en blanco"unless model[attribute]? 
    

cp = new CartProduct({name: 'Test', last_name: 'last'})

console.log cp
# console.log cp.name
# console.log cp.last_name