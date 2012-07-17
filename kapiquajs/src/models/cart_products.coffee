_ = require('underscore')
pg = require('pg')
util = require('util')
Config = require('../config')
Validate = require('./validator')
ModelBase = require('./model_base')

class CartProduct
  constructor: (@attributes)->
    throw "Wrong initialization types or null" unless _.isObject(@attributes)
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
  
  @all: (err_cb, cb) =>
    @_ensureDbIsSet(err_cb, cb)
    getAll = CartProduct.getConnection().query("SELECT * from #{@getTableName()}")
    results = []
    getAll.on 'row', (row)->
      results.push(new CartProduct(row))
    getAll.on 'end', (endResults) ->
      cb(results)
    getAll.on 'error', (error) ->
      err_cb(error)
      
  @findOne: (key_id, err_cb, cb) =>
    @_ensureDbIsSet(err_cb, cb)
    getOne = CartProduct.getConnection().query("SELECT * from #{@getTableName()} WHERE id = $1 LIMIT 1", [key_id])
    getOne.on 'row', (row) ->
      cb(new CartProduct(row))
    getOne.on 'error', (error) ->
      err_cb(error)
  
  
  save: (err_cb, cb)->
    return err_cb(@errors) unless @isValid()
    throw 'No values given' if _.isEmpty(@attributes)
    attribute_list= _.keys(@attributes)
    indeces = _.map [1..(attribute_list.length + 2)], (index)-> "$#{index}"
    attribute_values = _.values(@attributes)
    attribute_list.push('created_at')
    attribute_list.push('updated_at')
    attribute_values.push(new Date())
    attribute_values.push(new Date())
    createOne = CartProduct.getConnection().query("INSERT INTO #{CartProduct.getTableName()}( #{attribute_list.join(', ')} ) VALUES (#{indeces.join(', ')}) RETURNING id", attribute_values)
    createOne.on 'row', (row)->
      CartProduct.findOne(row.id,err_cb, cb)
    createOne.on 'error', (error)->
      err_cb(error)
  
  @_ensureDbIsSet: (err_cb, cb)->
    throw "table not specified" if not CartProduct.getTableName()? or CartProduct.getTableName() == ''
    throw "error callback missing" unless err_cb?
    throw "callback missing" unless cb?
    
   


err_handler = (errors)->
  console.log errors
success_handler = (results) ->
  console.log results

CartProduct.setTableName('cart_products')
cp = new CartProduct({cart_id:1, product_id: 1, quantity: 1})
cp.save(err_handler, success_handler)

