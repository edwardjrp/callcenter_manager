var CartProducts, Carts, Clients, app, express, io, pg, util, _;

express = require('express');

_ = require('underscore');

pg = require('pg');

util = require('util');

CartProducts = require('./routes/cart_products');

Carts = require('./routes/carts');

Clients = require('./routes/clients');

app = module.exports = express.createServer();

io = require('socket.io').listen(app);

app.configure(function() {
  app.use(express.logger({
    immediate: true,
    format: 'dev'
  }));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  return app.use(app.router);
});

app.configure('development', function() {
  return app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }));
});

app.configure('production', function() {
  return app.use(express.errorHandler());
});

io.sockets.on("connection", function(socket) {
  socket.on("cart_products:create", function(data, responder) {
    return CartProducts.create(data, responder, socket);
  });
  socket.on("cart_products:update", function(data, responder) {
    return CartProducts.update(data, responder, socket);
  });
  socket.on("cart_products:delete", function(data, responder) {
    return CartProducts.destroy(data, responder, socket);
  });
  socket.on('chat', function(data) {
    return io.sockets.emit('chat', data);
  });
  socket.on("clients:olo:index", function(data, responder) {
    return Clients.olo_with_phone(data, responder, socket);
  });
  socket.on("cart:price", function(data, responder) {
    return Carts.price(data, responder, socket);
  });
  return socket.on("cart:place", function(data, responder) {
    return Carts.place(data, responder, socket);
  });
});

process.on('uncaughtException', function(err) {
  return console.log(err);
});

app.listen(3030, function() {
  return console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
