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
  socket.on "cart_products:create", cartProducts.create
  socket.on "cart_products:update", cartProducts.update
  socket.on "cart_products:delete", cartProducts.destroy
    


process.on 'uncaughtException', (err)->
    console.log(err)

app.listen 3030, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
