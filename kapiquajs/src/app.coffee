# 
# Module dependencies.


express = require('express')
_ = require('underscore')
pg = require('pg')
util = require('util')
request = require('request')
cartProducts = require('./routes/cart_products')

app = module.exports = express.createServer()

io = require('socket.io').listen(app)

# Configuration
setCors = (req,res, next) ->
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
  res.contentType('application/json')
  if ('OPTIONS' == req.method)
    res.send(200)
  else
    next()
    
app.configure ->
  app.use(express.logger({ immediate: true, format: 'dev' }))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(setCors)
  app.use(app.router)
  


app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))


app.configure 'production', ->
  app.use(express.errorHandler())



# Routes
app.post '/cart_products',setCors, cartProducts.create
app.del '/cart_products',setCors, cartProducts.destroy

io.sockets.on "connection", (socket) ->
  socket.on "cart_products:create", cartProducts.create
  socket.on "cart_products:delete", cartProducts.destroy
    


process.on 'uncaughtException', (err)->
    console.log(err)

app.listen 3030, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
