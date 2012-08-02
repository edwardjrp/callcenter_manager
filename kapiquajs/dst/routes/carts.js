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
    return console.log('Princing');
  };

  Carts.place = function(data, respond, socket) {
    return console.log('Placing');
  };

  return Carts;

}).call(this);

module.exports = Carts;
