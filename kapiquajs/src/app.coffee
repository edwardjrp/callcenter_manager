# 
# Module dependencies.


express = require('express')
_ = require('underscore')
pg = require('pg')
util = require('util')
CartProducts = require('./routes/cart_products')
Carts = require('./routes/carts')
Clients = require('./routes/clients')

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


operators = []
administrators = []
# Routes

io.sockets.on "connection", (socket) ->

  socket.on 'register', (data, responder) ->
    socket.join('system')
    if data.role == 'admin'
      if _.find(administrators, ( admin ) -> admin.idnumber == data.idnumber)
        responder(true)
      else
        responder(false)
        socket.idnumber = data.idnumber
        administrators.push data
        socket.join('admins')
    else if data.role == 'operator'
      if _.find(operators, ( op ) -> op.idnumber == data.idnumber)
        responder(true)
      else
        responder(false)
        socket.idnumber = data.idnumber
        operators.push data
        socket.join("admins-#{data.idnumber}")
        for admin in administrators
          admin_socket = _.find( io.sockets.clients(), (skt) -> skt.idnumber == admin.idnumber )
          admin_socket.join("admins-#{data.idnumber}")
    io.sockets.in('admins').emit('register_client', operators)


  socket.on 'chat', (data)->
    io.sockets.emit('chat', data);

  socket.on "cart_products:create", (data, responder) ->
    CartProducts.create(data, responder, socket)
    
  socket.on "cart_products:update", (data, responder) ->
    CartProducts.update(data, responder, socket)
    
  socket.on "cart_products:delete", (data, responder) ->
    CartProducts.destroy(data, responder, socket)

  socket.on "clients:olo:phone", (data, responder) ->
    Clients.olo_with_phone(data, responder, socket)  

  socket.on "clients:olo:index", (data, responder) ->
    Clients.olo_index(data, responder, socket)  

  socket.on "clients:olo:show", (data, responder) ->
    Clients.olo_show(data, responder, socket)  
    
  socket.on "cart:price", (data, responder) ->
    Carts.price(data, responder, socket)

  socket.on "cart:place", (data, responder) ->
    Carts.place(data, responder, socket)


process.on 'uncaughtException', (err)->
    console.log(err)

app.listen 3030, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
