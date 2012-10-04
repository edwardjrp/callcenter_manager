CartCoupon = require('./schema').CartCoupon
_ = require('underscore')

CartCoupon.addCoupon = (data, respond, socket) ->
  if data?
    console.log data
    search_data = {cart_id : data.cart_id, coupon_id : data.coupon_id}
    CartCoupon.all {where:search_data}, (cc_err, cart_coupons) ->
      if cc_err
        console.error cc_err
      else
        if _.isEmpty(cart_coupons)
          target_products =  JSON.stringify(data.target_products) if data.target_products?  
          cart_coupon = new CartCoupon({cart_id : data.cart_id, code: data.coupon_code, coupon_id : data.coupon_id, target_products: target_products})
          cart_coupon.save (s_cc_err, saved_cart_coupon) ->
            if s_cc_err
              console.error s_cc_err
              # emit error
            else
              saved_cart_coupon.cart (err, cart) ->
                unless err
                  cart.price(socket)
              socket.emit('cart_coupon:saved', saved_cart_coupon)




module.exports = CartCoupon