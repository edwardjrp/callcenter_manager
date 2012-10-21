CartCoupon = require('../models/cart_coupon')

class CartCoupons
  
  @create: (data, respond, socket) =>
    CartCoupon.addCoupon(data, respond, socket)
    


  @destroy: (data, respond, socket) ->
    CartCoupon.removeCoupon(data, respond, socket)
          

module.exports = CartCoupons