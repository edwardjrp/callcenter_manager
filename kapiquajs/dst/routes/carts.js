var Cart, CartProduct, Carts, Client, OrderReply, Product, PulseBridge, Store, async, _;

Cart = require('../models/cart');

Product = require('../models/product');

Client = require('../models/client');

Store = require('../models/store');

CartProduct = require('../models/cart_product');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

async = require('async');

_ = require('underscore');

Carts = (function() {

  function Carts() {}

  Carts.price = function(data, respond, socket) {
    console.log(data.cart_id);
    return Cart.find(data.cart_id, function(cart_find_err, cart) {
      if (cart_find_err != null) {
        if (socket != null) {
          return socket.emit('data_error', {
            type: 'error_recuperando datos de la orden',
            msg: JSON.stringify(cart_find_err)
          });
        }
      } else {
        cart.client(function(cart_client_err, client) {
          return socket.emit('chat', {
            user: 'system ',
            msg: JSON.stringify(client)
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
