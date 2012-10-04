var CartCoupons, CartProducts, Carts, Clients, administrators, app, express, io, operators, pg, util, _;

express = require('express');

_ = require('underscore');

pg = require('pg');

util = require('util');

CartProducts = require('./routes/cart_products');

CartCoupons = require('./routes/cart_coupons');

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

operators = [];

administrators = [];

io.sockets.on("connection", function(socket) {
  socket.on('register', function(data, responder) {
    var admin, admin_socket, _i, _len;
    socket.join('system');
    if (data.role === 'admin') {
      if (_.find(administrators, function(admin) {
        return admin.idnumber === data.idnumber;
      })) {
        responder(true);
      } else {
        responder(false);
        socket.idnumber = data.idnumber;
        administrators.push(data);
      }
      socket.join('admins');
    } else if (data.role === 'operator') {
      if (_.find(operators, function(op) {
        return op.idnumber === data.idnumber;
      })) {
        responder(true);
      } else {
        responder(false);
        socket.idnumber = data.idnumber;
        operators.push(data);
      }
      socket.join("admins-" + data.idnumber);
      socket.emit('set_admin', 'connected');
      for (_i = 0, _len = administrators.length; _i < _len; _i++) {
        admin = administrators[_i];
        admin_socket = _.find(io.sockets.clients(), function(skt) {
          return skt.idnumber === admin.idnumber;
        });
        admin_socket.join("admins-" + data.idnumber);
      }
    }
    return io.sockets["in"]('admins').emit('register_client', operators);
  });
  socket.on('disconnect', function() {
    var admin_to_remove, operator_to_remove;
    if (!socket.idnumber) {
      return;
    }
    operator_to_remove = _.find(operators, function(op) {
      return op.idnumber === socket.idnumber;
    });
    admin_to_remove = _.find(administrators, function(admin) {
      return admin.idnumber === socket.idnumber;
    });
    if (operator_to_remove != null) {
      operators = _.without(operators, operator_to_remove);
    } else if (admin_to_remove != null) {
      administrators = _.without(administrators, admin_to_remove);
    }
    return io.sockets["in"]('admins').emit('register_client', operators);
  });
  socket.on('send_message', function(data, responder) {
    if (data.role === 'admin') {
      io.sockets["in"]("admins-" + data.to).emit('server_message', data);
    } else if (data.role === 'operator') {
      io.sockets["in"]('admins').emit('server_message', data);
    }
    return responder(data);
  });
  socket.on('chat', function(data) {
    return io.sockets.emit('chat', data);
  });
  socket.on("cart_products:create", function(data, responder) {
    return CartProducts.create(data, responder, socket);
  });
  socket.on("cart_products:update", function(data, responder) {
    return CartProducts.update(data, responder, socket);
  });
  socket.on("cart_products:delete", function(data, responder) {
    return CartProducts.destroy(data, responder, socket);
  });
  socket.on("cart_coupons:create", function(data, responder) {
    return CartCoupons.create(data, responder, socket);
  });
  socket.on("cart_coupons:delete", function(data, responder) {
    return CartCoupons.destroy(data, responder, socket);
  });
  socket.on("clients:olo:phone", function(data, responder) {
    return Clients.olo_with_phone(data, responder, socket);
  });
  socket.on("clients:olo:index", function(data, responder) {
    return Clients.olo_index(data, responder, socket);
  });
  socket.on("clients:olo:show", function(data, responder) {
    return Clients.olo_show(data, responder, socket);
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
