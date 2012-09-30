var CartProduct, Option, async, _;

CartProduct = require('./schema').CartProduct;

Option = require('./option');

async = require('async');

_ = require('underscore');

CartProduct.validatesPresenceOf('cart_id');

CartProduct.validatesPresenceOf('product_id');

CartProduct.validatesPresenceOf('quantity');

CartProduct.validatesNumericalityOf('quantity');

CartProduct.add = function(data, respond, socket) {
  var options, search_hash;
  options = Option.pulseCollection(data.options);
  search_hash = {
    cart_id: data.cart,
    product_id: data.product.id,
    options: options
  };
  return CartProduct.all({
    where: search_hash
  }, function(cp_err, cart_products) {
    var cart_product;
    if (_.isEmpty(cart_products)) {
      cart_product = new CartProduct({
        cart_id: data.cart,
        product_id: data.product.id,
        options: '',
        bind_id: data.bind_id,
        quantity: Number(data.quantity),
        created_at: new Date()
      });
    } else {
      cart_product = _.first(cart_products);
      cart_product.quantity = cart_product.quantity + Number(data.quantity);
    }
    return cart_product.save(function(err, model) {
      if (err) {
        return respond(err);
      } else {
        return respond(err, model);
      }
    });
  });
};

module.exports = CartProduct;
