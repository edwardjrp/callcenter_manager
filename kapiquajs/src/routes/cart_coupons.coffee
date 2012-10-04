CartCoupon = require('../models/cart_coupon')

class CartCoupons
  
  @create: (data, respond, socket) =>
    CartCoupon.addCoupon(data, respond, socket)
    


  @destroy: (data, respond, socket) ->
    console.log data
    respond('DELETE IT')
    # CartProduct.removeItem(data, respond, socket, true)
          

module.exports = CartCoupons