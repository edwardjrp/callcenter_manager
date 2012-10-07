var Cart, CartProduct, OrderReply, PulseBridge, Setting, async, _;

Cart = require('./schema').Cart;

async = require('async');

_ = require('underscore');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

CartProduct = require('../models/cart_product');

Setting = require('../models/setting');

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
          return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
        } else {
          current_cart_products = _.map(cart_products, function(cart_product) {
            return cart_product.simplified();
          });
          return callback(null, current_cart_products);
        }
      });
    }, function(current_cart_products, callback) {
      return me.products(function(c_p_err, products) {
        if (c_p_err) {
          return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
        } else {
          _.each(current_cart_products, function(current_cart_product) {
            return current_cart_product.product = _.find(products, function(product) {
              return product.id === current_cart_product.product_id;
            });
          });
          return callback(null, current_cart_products);
        }
      });
    }, function(current_cart_products, callback) {
      return me.cart_coupons(function(c_c_err, cart_coupons) {
        var current_cart_coupons;
        if (c_c_err) {
          console.error(c_c_err.stack);
          return socket.emit('cart:price:error', 'No se pudo acceder a la lista de cupones para esta orden');
        } else {
          current_cart_coupons = _.map(cart_coupons, function(cart_coupon) {
            return cart_coupon.simplified();
          });
          return callback(null, current_cart_products, current_cart_coupons);
        }
      });
    }
  ], function(final_error, current_cart_products, current_cart_coupons) {
    var current_cart, pulse_com_error;
    if (final_error != null) {
      console.error(final_error.stack);
      return socket.emit('cart:price:error', 'Un error impidio solitar el precio de esta orden');
    } else {
      current_cart = me.simplified();
      current_cart.cart_products = current_cart_products;
      current_cart.cart_coupons = current_cart_coupons;
      pulse_com_error = function(comm_err) {
        return socket.emit('cart:price:error', 'Un error de comunicación impidio solitar el precio de esta orden, la aplicacion no podra funcionar correctamente en este estado');
      };
      if (current_cart_products.length > 0) {
        return Setting.kapiqua(function(err, settings) {
          var cart_request;
          if (err) {
            return console.error(err.stack);
          } else {
            cart_request = new PulseBridge(current_cart, settings.price_store_id, settings.price_store_ip, settings.pulse_port);
            try {
              return cart_request.price(pulse_com_error, function(res_data) {
                var order_reply;
                order_reply = new OrderReply(res_data, current_cart_products);
                me.updatePrices(order_reply, socket);
                socket.emit('cart:priced', {
                  order_reply: order_reply,
                  items: order_reply.products()
                });
                console.info(order_reply);
                if (order_reply.status === '6') {
                  return socket.emit('cart:coupons:autocomplete', current_cart_coupons);
                }
              });
            } catch (err_pricing) {
              return console.error(err_pricing.stack);
            }
          }
        });
      } else {
        return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
      }
    }
  });
};

Cart.prototype.updatePrices = function(order_reply, socket) {
  return this.updateAttributes({
    can_place_order: order_reply.can_place,
    net_amount: order_reply.netamount,
    tax_amount: order_reply.taxamount,
    tax1_amount: order_reply.tax1amount,
    tax2_amount: order_reply.tax2amount,
    payment_amount: order_reply.payment_amount
  }, function(err, updated_cart) {
    if (err) {
      console.error(err.stack);
      return socket.emit('cart:price:error', 'No se pudo actualizar los precios en la base de datos');
    } else {
      return _.each(order_reply.products(), function(pricing) {
        return CartProduct.find(pricing.cart_product_id, function(cp_err, cart_product) {
          if (!cp_err) {
            return cart_product.updateAttributes({
              priced_at: pricing.priced_at
            }, function(update_err, updated_cart_product) {
              if (update_err) {
                return console.error(update_err);
              }
            });
          }
        });
      });
    }
  });
};

Cart.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = Cart;
