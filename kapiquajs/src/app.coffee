# 
# Module dependencies.


express = require('express')
_ = require('underscore')
pg = require('pg')
util = require('util')
CartProducts = require('./routes/cart_products')
Carts = require('./routes/carts')

app = module.exports = express.createServer()

io = require('socket.io').listen(app)

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



# Routes

io.sockets.on "connection", (socket) ->
  socket.on "cart_products:create", (data, responder) ->
    CartProducts.create(data, responder, socket)
    
  socket.on "cart_products:update", (data, responder) ->
    CartProducts.update(data, responder, socket)
    
  socket.on "cart_products:delete", (data, responder) ->
    CartProducts.destroy(data, responder, socket)
  
  socket.on 'chat', (data)->
    io.sockets.emit('chat', data);
    
  socket.on "cart:price", (data, responder) ->
    Carts.price(data, responder, socket)

  socket.on "cart:place", (data, responder) ->
    Carts.place(data, responder, socket)


process.on 'uncaughtException', (err)->
    console.log(err)

app.listen 3030, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
