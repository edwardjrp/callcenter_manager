_ = require('underscore')
pg = require('pg')
util = require('util')
Config = require('../config')



class CartProduct
  constructor: (@attributes)->
    throw "Wrong initialization types" unless _.isObject(@attributes)
    this['validate'] = new Validate(this)
    this['errors'] = []
    _.each _.keys(attributes), (key) =>
      this["#{key}"] = attributes["#{key}"]
          
  @getConnection = ->
    Config.setup() unless Config.getConnection()?
    Config.getConnection()

          
  @setTableName = (name)->
    @tableName = name
    
  @getTableName = ()->
    @tableName
    
  isValid: ()->
    @validate.presenceOf('cart_id')
    @validate.numericalityOf('cart_id')
    @validate.presenceOf('product_id')
    @validate.numericalityOf('product_id')
    @validate.presenceOf('quantity')
    @validate.numericalityOf('quantity')
    _.isEmpty(@errors)
  
  @all: (err_cb, cb)->
    throw "table not specified" if not CartProduct.getTableName()? or CartProduct.getTableName() == ''
    throw "error callback missing" unless err_cb?
    throw "callback missing" unless cb?
    getAll = CartProduct.getConnection().query("SELECT * from #{CartProduct.getTableName()}")
    results = []
    getAll.on 'row', (row)->
      results.push row
    getAll.on 'end', (endResults) ->
      cb(results)
    getAll.on 'error', (error) ->
      err_cb.call(error)
  
        
class Validate
  constructor: (@model)->
  presenceOf: (attribute) ->
    throw 'Incorrect argument type : should be a string' unless _.isString(attribute)
    unless @model[attribute]? 
      @model.errors.push("#{attribute} no puede estar en blanco")
      
  numericalityOf: (attribute) ->
    throw 'Incorrect argument type : should be a string' unless _.isString(attribute)
    unless @model[attribute]? and _.isNumber(@model[attribute]) 
      @model.errors.push("#{attribute} no puede estar en blanco")
   

err_handler = (errors)->
  console.log errors
success_handler = (results) ->
  console.log results

CartProduct.setTableName('cart_products')
CartProduct.all( err_handler, success_handler)
