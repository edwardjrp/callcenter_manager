var CartCoupon, _;

CartCoupon = require('./schema').CartCoupon;

_ = require('underscore');

CartCoupon.addCoupon = function(data, respond, socket) {
  var search_data;
  if (data != null) {
    search_data = {
      cart_id: data.cart_id,
      coupon_id: data.coupon_id
    };
    return CartCoupon.all({
      where: search_data
    }, function(cc_err, cart_coupons) {
      var cart_coupon, target_products;
      if (cc_err) {
        return console.error(cc_err);
      } else {
        if (_.isEmpty(cart_coupons)) {
          if (data.target_products != null) {
            target_products = JSON.stringify(data.target_products);
          }
          cart_coupon = new CartCoupon({
            cart_id: data.cart_id,
            code: data.coupon_code,
            coupon_id: data.coupon_id,
            target_products: target_products
          });
          return cart_coupon.save(function(s_cc_err, saved_cart_coupon) {
            if (s_cc_err) {
              return console.error(s_cc_err);
            } else {
              saved_cart_coupon.cart(function(err, cart) {
                if (!err) {
                  return cart.price(socket);
                }
              });
              return socket.emit('cart_coupon:saved', saved_cart_coupon);
            }
          });
        }
      }
    });
  }
};

CartCoupon.removeItem = function(data, respond, socket) {
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
              socket.emit('cart_coupons:deleted', data.id);
              return cart.price(socket);
            }
          });
        });
      }
    });
  }
};

module.exports = CartCoupon;
