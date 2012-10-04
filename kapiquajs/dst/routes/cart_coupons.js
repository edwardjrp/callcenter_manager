var CartCoupon, CartCoupons;

CartCoupon = require('../models/cart_coupon');

CartCoupons = (function() {

  function CartCoupons() {}

  CartCoupons.create = function(data, respond, socket) {
    return CartCoupon.addCoupon(data, respond, socket);
  };

  CartCoupons.destroy = function(data, respond, socket) {
    return CartCoupon.removeItem(data, respond, socket);
  };

  return CartCoupons;

}).call(this);

module.exports = CartCoupons;
