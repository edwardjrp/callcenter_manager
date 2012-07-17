_ = require('underscore')

class Validate
  constructor: (@model)->
  presenceOf: (attribute) ->
    throw 'Incorrect argument type : should be a string' unless _.isString(attribute)
    unless @model[attribute]? 
      @model.errors.push("#{attribute} can't nil blank")
      
  numericalityOf: (attribute) ->
    throw 'Incorrect argument type : should be a string' unless _.isString(attribute)
    unless @model[attribute]? and _.isNumber(@model[attribute]) 
      @model.errors.push("#{attribute} can't nil blank")
      
module.exports = Validate