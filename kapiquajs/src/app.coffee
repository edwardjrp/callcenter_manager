# 
# Module dependencies.


express = require('express')
_ = require('underscore')
pg = require('pg')
util = require('util')
request = require('request')
cartProducts = require('./routes/cart_products')

app = module.exports = express.createServer()
# Configuration

app.configure ->
  app.use(express.logger({ immediate: true, format: 'dev' }))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)


app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))


app.configure 'production', ->
  app.use(express.errorHandler())

setCors = (req,res, next) ->
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000')
  res.header('Access-Control-Allow-Methods', '*')
  res.contentType('application/json')
  next()

# Routes
app.post '/cart_products',setCors, cartProducts.create

process.on 'uncaughtException', (err)->
    console.log(err)

app.listen 3030, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
