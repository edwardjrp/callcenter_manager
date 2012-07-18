_ = require('underscore')
pg = require('pg')
util = require('util')
Config = require('../config')
Validate = require('./validator')

class BaseModel
  constructor: (@attributes)->
    throw "Constructor: Wrong initialization types or null" unless _.isObject(@attributes)
    this['validate'] = new Validate(this)
    this['errors'] = []
    @setAttributes()
          
  @getConnection = ->
    Config.setup() unless Config.getConnection()?
    Config.getConnection()

          
  @setTableName = (name)->
    @tableName = name
    
  @getTableName = ()->
    throw 'GetTableName: Table name not set' unless @tableName?
    @tableName
    
  
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
    getOne = @getConnection().query("SELECT * from #{@getTableName()} WHERE id = $1 LIMIT 1", [key_id])
    getOne.on 'row', (row) =>
      cb(new this(row))
    getOne.on 'error', (error) ->
      err_cb(error)
  
  @count: (err_cb, cb)=>
      getCount = @getConnection().query("SELECT COUNT(*) from #{@getTableName()}")
      results = []
      getCount.on 'row', (result)->
        cb(result.count)
      getCount.on 'error', (error) ->
        err_cb(error)



  @_ensureDbIsSet: (err_cb, cb)=>
    throw "table not specified" if not @getTableName()? or @getTableName() == ''
    throw "error callback missing" unless err_cb?
    throw "callback missing" unless cb?
  
  
  setAttributes: ()=>
    _.each _.keys(@attributes), (key) =>
      this["#{key}"] = @attributes["#{key}"]    
  
  
      
  isDirty: ()=>
    dirty = false    
    _.each _.keys(@attributes), (key) =>
      dirty = true unless this["#{key}"] == @attributes["#{key}"]
    dirty
      
      
  isValid: ()->
    result = _.isEmpty(@errors)
    @errors = []
    result
  
  create: (err_cb, cb)->
    return err_cb(@errors) unless @isValid()
    throw 'No values given' if _.isEmpty(@attributes)
    attribute_list= _.keys(@attributes)
    indeces = _.map [1..(attribute_list.length + 2)], (index)-> "$#{index}"
    attribute_values = _.values(@attributes)
    attribute_list.push('created_at')
    attribute_list.push('updated_at')
    attribute_values.push(new Date())
    attribute_values.push(new Date())
    createOne = this.constructor.getConnection().query("INSERT INTO #{this.constructor.getTableName()}( #{attribute_list.join(', ')} ) VALUES (#{indeces.join(', ')}) RETURNING id", attribute_values)
    createOne.on 'row', (row)->
      this.constructor.findOne(row.id,err_cb, cb)
    createOne.on 'error', (error)->
      err_cb(error)
      
  update: (err_cb, cb)->
    return err_cb(@errors) unless @isValid()
    throw 'No values given' if _.isEmpty(@attributes)
    throw 'Object is new' unless @id? and _.isNumber(@id) and @id > 0
    attribute_list= _.keys(@attributes)
    indeces = _.map [1..(attribute_list.length)], (index)-> "$#{index}"
    attribute_values = _.map attribute_list, (key)=> this["#{key}"]
    @updated_at = new Date()
    pairs = _.map _.zip(attribute_list, indeces), (pair) -> pair.join('=')
    updateOne = CartProduct.getConnection().query("UPDATE #{this.constructor.getTableName()} SET #{pairs.join(', ')} WHERE id = #{@id} RETURNING *", attribute_values)
    updateOne.on 'row', (cart_product)->
      this.constructor.findOne(cart_product.id,err_cb, cb)
    updateOne.on 'error', (error)->
      err_cb(error)

  destroy: (err_cb, cb)->
    throw 'No values given' if _.isEmpty(@attributes)
    throw 'Object is new' unless @id? and _.isNumber(@id) and @id > 0
    destroyOne = this.constructor.getConnection().query("DELETE FROM #{CartProduct.getTableName()} WHERE id = $1", [@id])
    destroyOne.on 'end', (result)=>
      this.id = null
      cb(result.rowCount)
    destroyOne.on 'error', (error)->
      err_cb(error)
    
