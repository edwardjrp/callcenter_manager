var CartProduct, CartProducts;

CartProduct = require('../models/cart_product');

CartProducts = (function() {

  function CartProducts() {}

  CartProducts.create = function(data, respond, socket) {
    return CartProduct.addItem(data, respond, socket, true);
  };

  CartProducts.update = function(data, respond, socket) {
    return CartProduct.updateItem(data, respond, socket, true);
  };

  CartProducts.destroy = function(data, respond, socket) {
    return CartProduct.removeItem(data, respond, socket, true);
  };

  return CartProducts;

}).call(this);

module.exports = CartProducts;
