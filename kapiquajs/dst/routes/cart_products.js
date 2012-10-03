var Cart, CartProduct, CartProducts, OrderReply, Product, PulseBridge, async, _;

Cart = require('../models/cart');

Product = require('../models/product');

CartProduct = require('../models/cart_product');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

async = require('async');

_ = require('underscore');

CartProducts = (function() {

  function CartProducts() {}

  CartProducts.create = function(data, respond, socket) {
    return CartProduct.addItem(data, respond, socket);
  };

  CartProducts.update = function(data, respond, socket) {
    return CartProduct.updateItem(data, respond, socket, true);
  };

  CartProducts.destroy = function(data, respond, socket) {
    return CartProduct.removeItem(data, respond, socket);
  };

  return CartProducts;

}).call(this);

module.exports = CartProducts;
