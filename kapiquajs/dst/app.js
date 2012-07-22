var app, cartProducts, express, io, pg, request, util, _;

express = require('express');

_ = require('underscore');

pg = require('pg');

util = require('util');

request = require('request');

cartProducts = require('./routes/cart_products');

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
  socket.on("cart_products:create", cartProducts.create);
  socket.on("cart_products:update", cartProducts.update);
  socket.on("cart_products:delete", cartProducts.destroy);
  return socket.on('chat', function(data) {
    return io.sockets.emit('chat', data);
  });
});

process.on('uncaughtException', function(err) {
  return console.log(err);
});

app.listen(3030, function() {
  return console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
