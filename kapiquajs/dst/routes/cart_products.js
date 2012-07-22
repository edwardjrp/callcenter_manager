var Cart, CartProduct, Product, async, current_cart, save_item, _;

CartProduct = require('../models/cart_product');

Cart = require('../models/cart');

Product = require('../models/product');

async = require('async');

_ = require('underscore');

exports.create = function(data, respond) {
  return CartProduct.all({
    where: {
      cart_id: data.cart,
      product_id: data.product.id,
      options: data.options
    }
  }, function(cp_err, cart_products) {
    var cart_product;
    if (_.isEmpty(cart_products)) {
      cart_product = new CartProduct({
        cart_id: data.cart,
        product_id: data.product.id,
        options: data.options,
        bind_id: data.bind_id,
        quantity: Number(data.quantity)
      });
    } else {
      cart_product = _.first(cart_products);
      cart_product.quantity = cart_product.quantity + Number(data.quantity);
    }
    return save_item(cart_product, data, respond);
  });
};

exports.update = function(data, respond) {
  return CartProduct.find(data.id, function(cp_err, cart_product) {
    if (cp_err != null) {
      return respond({
        type: "error",
        data: 'El articulo no esta presente'
      });
    } else {
      return cart_product.updateAttributes({
        options: data.options,
        quantity: Number(data.quantity)
      }, function(err) {
        if ((err != null)) {
          console.log(cart_product.errors);
          console.log(err);
          return respond({
            type: "error",
            data: cart_product.errors || err
          });
        } else {
          return current_cart(cart_product.cart_id, data, respond);
        }
      });
    }
  });
};

exports.destroy = function(data, respond) {
  var current_cart_id;
  current_cart_id = data.cart;
  if (current_cart_id != null) {
    return CartProduct.find(data.id, function(cp_err, cart_product) {
      if (cp_err) {
        return respond({
          type: "error",
          data: 'El articulo no esta presente'
        });
      } else {
        return cart_product.destroy(function(del_err) {
          if (del_err != null) {
            console.log(cart_product.errors);
            console.log(del_err);
            return respond({
              type: "error",
              data: cart_product.errors || del_err
            });
          } else {
            return current_cart(current_cart_id, data, respond);
          }
        });
      }
    });
  }
};

save_item = function(cart_product, data, respond) {
  return cart_product.save(function(err) {
    if ((err != null)) {
      console.log(cart_product.errors);
      console.log(err);
      return respond({
        type: "error",
        data: cart_product.errors || err
      });
    } else {
      return current_cart(cart_product.cart_id, data, respond);
    }
  });
};

current_cart = function(cart_id, data, respond) {
  return Cart.find(cart_id, function(c_err, cart) {
    return cart.cart_products({}, function(c_cp_err, cart_products) {
      var get_products;
      get_products = function(cp, cb) {
        return Product.find(cp.product(), function(p_err, product) {
          var json_cp;
          json_cp = JSON.parse(JSON.stringify(cp));
          json_cp.product = JSON.parse(JSON.stringify(product));
          return cb(null, json_cp);
        });
      };
      return async.map(cart_products, get_products, function(err, results) {
        var json_cart;
        if (err) {
          return respond({
            type: "error",
            data: err
          });
        } else {
          json_cart = JSON.parse(JSON.stringify(cart));
          json_cart.cart_products = results;
          return respond({
            type: "success",
            data: json_cart
          });
        }
      });
    });
  });
};
