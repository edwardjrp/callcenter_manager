var Address, Cart, CartProduct, Carts, Client, OrderReply, Phone, Product, PulseBridge, Store, async, _;

Cart = require('../models/cart');

Product = require('../models/product');

Client = require('../models/client');

Store = require('../models/store');

Phone = require('../models/phone');

Address = require('../models/address');

CartProduct = require('../models/cart_product');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

async = require('async');

_ = require('underscore');

Carts = (function() {

  function Carts() {}

  Carts.price = function(data, respond, socket) {
    return Cart.find(data.cart_id, function(cart_find_err, cart) {
      if (cart_find_err != null) {
        if (socket != null) {
          return socket.emit('cart:price:error', {
            error: JSON.stringify(cart_find_err)
          });
        }
      } else {
        cart.client(function(cart_client_err, client) {
          socket.emit('cart:price:client', {
            client: client
          });
          if ((client.phones_count != null) && client.phones_count > 0) {
            return client.phones(function(cart_client_phones_err, phones) {
              if (cart_client_phones_err != null) {
                if (socket != null) {
                  return socket.emit('cart:price:error', {
                    error: JSON.stringify(cart_client_phones_err)
                  });
                }
              } else {
                if (socket != null) {
                  return socket.emit('cart:price:client:phones', {
                    phones: phones
                  });
                }
              }
            });
          }
        });
        cart.cart_products({}, function(c_cp_err, cart_products) {
          var get_products;
          get_products = function(cp, cb) {
            return cp.product(function(p_err, product) {
              var json_cp;
              json_cp = JSON.parse(JSON.stringify(cp));
              json_cp.product = JSON.parse(JSON.stringify(product));
              return cb(null, json_cp);
            });
          };
          return async.map(cart_products, get_products, function(it_err, results) {
            if (it_err) {
              if (socket != null) {
                return socket.emit('cart:price:error', {
                  error: JSON.stringify(cart_client_phones_err)
                });
              }
            } else {
              if (socket != null) {
                return socket.emit('cart:price:client:cartproducts', {
                  results: results
                });
              }
            }
          });
        });
        return console.log('Princing');
      }
    });
  };

  Carts.place = function(data, respond, socket) {
    return console.log('Placing');
  };

  return Carts;

}).call(this);

module.exports = Carts;
