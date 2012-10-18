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
    if (data != null) {
      return Cart.find(data, function(cart_find_err, cart) {
        if (cart_find_err != null) {
          console.error(cart_find_err.stack);
          return socket.emit('cart:price:error', 'La orden no se encontro en el sistema');
        } else {
          return cart.price(socket);
        }
      });
    }
  };

  Carts.place = function(data, respond, socket) {
    if (data != null) {
      return Cart.find(data.cart_id, function(cart_find_err, cart) {
        if (cart_find_err != null) {
          console.error(cart_find_err.stack);
          return socket.emit('cart:place:error', 'La orden no se encontro en el sistema');
        } else {
          return cart.place(data, socket);
        }
      });
    }
  };

  return Carts;

}).call(this);

module.exports = Carts;
