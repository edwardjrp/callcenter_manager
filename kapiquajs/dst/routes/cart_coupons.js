var CartCoupon, CartCoupons;

CartCoupon = require('../models/cart_coupon');

CartCoupons = (function() {

  function CartCoupons() {}

  CartCoupons.create = function(data, respond, socket) {
    return CartCoupon.addCoupon(data, respond, socket);
  };

  CartCoupons.destroy = function(data, respond, socket) {
    console.log(data);
    return respond('DELETE IT');
  };

  return CartCoupons;

}).call(this);

module.exports = CartCoupons;
