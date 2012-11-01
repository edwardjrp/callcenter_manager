# 
# Module dependencies.


express = require('express')
_ = require('underscore')
pg = require('pg')
util = require('util')
CartProducts = require('./routes/cart_products')
CartCoupons = require('./routes/cart_coupons')
Carts = require('./routes/carts')
Clients = require('./routes/clients')
Stores = require('./routes/stores')


app = module.exports = express.createServer()

io = require('socket.io').listen(app)

# Configuration
    
app.configure ->
  app.use(express.logger({ immediate: true, format: 'dev' }))
  app.use(express.bodyParser())
  app.set('port', 3030)
  app.use(express.methodOverride())
  app.use(app.router)
  


app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))


app.configure 'production', ->
  app.use(express.errorHandler())

app.configure 'test', ->
  app.set('port', 3031)


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
      socket.emit('set_admin', 'connected')
      for admin in administrators
        admin_socket = _.find( io.sockets.clients(), (skt) -> skt.idnumber == admin.idnumber )
        if admin_socket?
          admin_socket.join("admins-#{data.idnumber}")
        else
          administrators = _.without(administrators, admin)
    io.sockets.in('admins').emit('register_client', operators)

  socket.on 'disconnect', () ->
    return unless socket.idnumber
    operator_to_remove = _.find(operators, ( op ) -> op.idnumber == socket.idnumber)
    admin_to_remove = _.find(administrators, ( admin ) -> admin.idnumber == socket.idnumber)
    if operator_to_remove?
      operators = _.without(operators, operator_to_remove)
    else if admin_to_remove?
      administrators = _.without(administrators, admin_to_remove)
    io.sockets.in('admins').emit('register_client', operators)

  socket.on 'send_message', (data, responder) ->
    if data.role == 'admin'
      io.sockets.in("admins-#{data.to}").emit('server_message',data)
    else if data.role == 'operator'
      io.sockets.in('admins').emit('server_message',data)
    responder(data)

  socket.on 'chat', (data)->
    io.sockets.emit('chat', data);

  # socket.on "carts:read", (data, responder) ->
  #   Carts.read(data, responder, socket)

  socket.on "cart_products:create", (data, responder) ->
    CartProducts.create(data, responder, socket)
    
  socket.on "cart_products:add_collection", (data, responder) ->
    CartProducts.addCollection(data, responder, socket)

  socket.on "cart_products:update", (data, responder) ->
    CartProducts.update(data, responder, socket)
    
  socket.on "cart_products:delete", (data, responder) ->
    CartProducts.destroy(data, responder, socket)

  socket.on "cart_coupons:create", (data, responder) ->
    CartCoupons.create(data, responder, socket)
    
  socket.on "cart_coupons:delete", (data, responder) ->
    CartCoupons.destroy(data, responder, socket)

  socket.on "clients:olo:phone", (data, responder) ->
    Clients.olo_with_phone(data, responder, socket)  

  socket.on "clients:olo:idnumber", (data, responder) ->
    Clients.olo_with_idnumber(data, responder, socket)  

  socket.on "clients:olo:index", (data, responder) ->
    Clients.olo_index(data, responder, socket)  

  socket.on "clients:olo:show", (data, responder) ->
    Clients.olo_show(data, responder, socket)  

  socket.on "stores:schedule", (data, responder) ->
    Stores.schedule(data, responder)

  socket.on "cart:status", (data, responder) ->
    Carts.status(data, responder, socket)
    
  socket.on "cart:price", (data, responder) ->
    Carts.price(data, responder, socket, io)

  socket.on "cart:place", (data, responder) ->
    Carts.place(data, responder, socket, io)


process.on 'uncaughtException', (err)->
    console.log(err.stack)

app.listen app.settings.port, ->
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
