var Cart, CartCoupon, CartProduct, _;

CartCoupon = require('./schema').CartCoupon;

CartProduct = require('../models/cart_product');

Cart = require('../models/cart');

_ = require('underscore');

CartCoupon.addCoupon = function(data, respond, socket) {
  if (data != null) {
    return Cart.find(data.cart_id, function(cart_error, cart) {
      if (cart_error) {
        console.error(cart_error.stack);
        return socket.emit("coupon:error", "No se pudo obtener los datos de la orden");
      } else {
        return cart.cart_products({}, function(cart_products_error, cart_products) {
          if (cart_products_error) {
            return console.error(cart_products_error.stack);
          } else {
            return cart.cart_coupons({
              where: {
                coupon_id: data.coupon_id
              }
            }, function(cc_err, cart_coupons) {
              var cart_coupon, target_products;
              if (cc_err) {
                return console.error(cc_err.stack);
              } else {
                if (data.target_products != null) {
                  target_products = JSON.stringify(data.target_products);
                }
                cart_coupon = new CartCoupon({
                  cart_id: cart.id,
                  code: data.coupon_code,
                  coupon_id: data.coupon_id,
                  target_products: target_products
                });
                return cart_coupon.save(function(s_cc_err, saved_cart_coupon) {
                  if (s_cc_err) {
                    return console.error(s_cc_err);
                  } else {
                    socket.emit('cart_coupon:saved', saved_cart_coupon);
                    return socket.emit('cart:coupons:autocomplete', saved_cart_coupon);
                  }
                });
              }
            });
          }
        });
      }
    });
  }
};

CartCoupon.removeCoupon = function(data, respond, socket) {
  if (data != null) {
    return CartCoupon.find(data.id, function(cc_err, cart_coupon) {
      if (cc_err) {
        return respond(cc_err);
      } else {
        return cart_coupon.cart(function(err, cart) {
          return cart_coupon.destroy(function(del_err) {
            if (del_err != null) {
              return respond(del_err);
            } else {
              socket.emit('cart_coupon:removed', data.id);
              try {
                if (!_.isUndefined(respond)) {
                  respond(del_err, data.id);
                }
                return cart.price(socket);
              } catch (e) {
                return console.error(e.stack);
              }
            }
          });
        });
      }
    });
  }
};

module.exports = CartCoupon;
