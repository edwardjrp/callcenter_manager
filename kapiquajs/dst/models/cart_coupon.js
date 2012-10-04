var CartCoupon, _;

CartCoupon = require('./schema').CartCoupon;

_ = require('underscore');

CartCoupon.addCoupon = function(data, respond, socket) {
  var search_data;
  if (data != null) {
    console.log(data);
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
              console.error(s_cc_err);
              return respond(s_cc_err);
            } else {
              saved_cart_coupon.cart(function(err, cart) {
                if (!err) {
                  socket.emit('cart_coupon:saved', saved_cart_coupon);
                  return cart.price(socket);
                }
              });
              return respond(s_cc_err, saved_cart_coupon);
            }
          });
        }
      }
    });
  }
};

module.exports = CartCoupon;
