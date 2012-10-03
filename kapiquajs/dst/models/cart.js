var Cart, OrderReply, PulseBridge, async, _;

Cart = require('./schema').Cart;

async = require('async');

_ = require('underscore');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

Cart.validatesPresenceOf('user_id');

Cart.prototype.products = function(cb) {
  return Cart.schema.adapter.query("SELECT \"products\".* FROM \"products\" INNER JOIN \"cart_products\" ON \"products\".\"id\" = \"cart_products\".\"product_id\" WHERE \"cart_products\".\"cart_id\" = " + this.id, function(err, collection) {
    if (err) {
      return cb(err);
    } else {
      return cb(err, collection);
    }
  });
};

Cart.prototype.price = function(socket) {
  var me;
  me = this;
  return async.waterfall([
    function(callback) {
      return me.cart_products({}, function(c_cp_err, cart_products) {
        var current_cart_products;
        if (c_cp_err) {
          if (socket != null) {
            return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
          }
        } else {
          current_cart_products = _.map(cart_products, function(cart_product) {
            return cart_product.simplified();
          });
          return callback(null, current_cart_products);
        }
      });
    }, function(current_cart_products, callback) {
      return me.products(function(c_p_err, products) {
        var updated_cart_products;
        if (c_p_err) {
          if (socket != null) {
            return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
          }
        } else {
          updated_cart_products = _.map(current_cart_products, function(current_cart_product) {
            return current_cart_product.product = _.find(products, function(product) {
              return product.id === current_cart_product.product_id;
            });
          });
          return callback(null, current_cart_products, updated_cart_products);
        }
      });
    }
  ], function(final_error, updated_cart_products, current_cart_products) {
    var current_cart, pulse_com_error;
    if (final_error != null) {
      console.log(final_error);
      if (socket != null) {
        return socket.emit('cart:price:error', 'Un error impidio solitar el precio de esta orden');
      }
    } else {
      current_cart = me.simplified();
      current_cart.cart_products = updated_cart_products;
      pulse_com_error = function(comm_err) {
        console.log(comm_err);
        if (socket != null) {
          return socket.emit('cart:price:error', {
            error: JSON.stringify(comm_err)
          });
        }
      };
      return PulseBridge.price(current_cart, pulse_com_error, function(res_data) {
        var order_reply;
        order_reply = new OrderReply(res_data);
        return console.log(order_reply);
      });
    }
  });
};

Cart.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = Cart;
