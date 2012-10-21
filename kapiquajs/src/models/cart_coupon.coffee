CartCoupon = require('./schema').CartCoupon
CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
_ = require('underscore')

CartCoupon.addCoupon = (data, respond, socket) ->
  if data?
    Cart.find data.cart_id, (cart_error, cart) ->
      if cart_error
        console.error cart_error.stack
        socket.emit "coupon:error", "No se pudo obtener los datos de la orden"
      else
        cart.cart_products {}, (cart_products_error, cart_products) ->
          if cart_products_error
            console.error cart_products_error.stack
          else
            cart.cart_coupons { where: {coupon_id : data.coupon_id} }, (cc_err, cart_coupons) ->
              if cc_err
                console.error cc_err.stack
              else
                if _.isEmpty(cart_coupons)
                  target_products =  JSON.stringify(data.target_products) if data.target_products?  
                  cart_coupon = new CartCoupon({cart_id : cart.id, code: data.coupon_code, coupon_id : data.coupon_id, target_products: target_products})
                  cart_coupon.save (s_cc_err, saved_cart_coupon) ->
                    if s_cc_err
                      console.error s_cc_err
                      # emit error
                    else
                      socket.emit('cart_coupon:saved', saved_cart_coupon)
                      socket.emit('cart:coupons:autocomplete', saved_cart_coupon )


CartCoupon.removeCoupon = (data, respond, socket) ->
  if data?
    CartCoupon.find data.id, (cc_err, cart_coupon) ->
      if cc_err
        respond(cc_err)
      else 
        cart_coupon.cart (err, cart) ->
          cart_coupon.destroy (del_err) ->
            if del_err?
              respond(del_err)
            else
              respond(del_err,  data.id)
              try
                cart.price(socket)  
              catch e
                console.error e.stack
              
              

module.exports = CartCoupon