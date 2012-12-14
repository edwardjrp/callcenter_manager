CartProduct = require('./schema').CartProduct
Product = require('../models/product')
async = require('async')
_ = require('underscore')
CartProduct.validatesPresenceOf('cart_id')
CartProduct.validatesPresenceOf('product_id')
CartProduct.validatesPresenceOf('quantity')
CartProduct.validatesNumericalityOf('quantity')


CartProduct.addItem = (data, respond, socket) ->
  if data?
    cart_product = new CartProduct({cart_id: data.cart_id, product_id: data.product_id, options: data.options, bind_id: data.bind_id, quantity: Number(data.quantity), created_at: new Date()})
    cart_product.save (err, result_cart_product) ->
      if (err)
        respond(err)
      else
        respond(err, result_cart_product)
        result_cart_product.cart (c_err, cart) ->
          if c_err
            socket.emit 'cart:pricing:error', 'No se pudo leer la orden actual'
          else
            cart.price(socket)
        

CartProduct.addCollection = (data, respond, socket) ->
  if data?
    cart = null
    addProduct = (coupon_product, callback) ->
      Product.all { where: { productcode: coupon_product.product_code } }, (product_error, products) ->
        if _.any(products)
          product = _.first(products)
          cart_product = new CartProduct({cart_id: data.cart_id, product_id: product.id, options: product.options, bind_id: null, quantity: Number(coupon_product.minimun_require) || 1, created_at: new Date()})
          cart_product.save (cart_product_save_error, saved_cart_product) ->
            if cart_product_save_error?
              console.error cart_product_save_error.stack
              callback(cart_product_save_error)
            else
              saved_cart_product.cart (saved_cart_product_error, current_cart) ->
                cart = current_cart
                saved_cart_product_to_send = saved_cart_product.toJSON()
                saved_cart_product_to_send.product = product.toJSON()
                saved_cart_product_to_send.cart = current_cart.toJSON()
                socket.emit 'cart_products:add:backwards', saved_cart_product_to_send
                callback()
        else
          socket.emit 'cart:pricing:error',  "El cupón hace referencia al producto #{coupon_product.product_code} pero este no se encontró en el listado"
          callback()
    async.forEach data.coupon_products, addProduct, (err)->
      if err
        console.error err.stack
      else
        if cart?
          process.nextTick ->
            cart.price(socket)
    

CartProduct.updateItem =  (data, respond, socket, trigger_pricing) ->
  if data?
    CartProduct.find data.id, (cp_err, cart_product) ->
        if cp_err?
          respond(cp_err)
        else
          if cart_product?
            attributes = {}
            attributes['product_id'] = data.product_id
            attributes['bind_id'] = data.bind_id || null
            attributes['quantity'] = Number(data.quantity) if data? and data.quantity?
            attributes['options'] = data.options if data? and data.options?
            attributes['updated_at'] = new Date()
            cart_product.updateAttributes attributes, (cp_update_err, updated_cart_product)->
              if cp_update_err?
                 respond(cp_update_err)
               else
                  socket.emit('cart_products:updated', updated_cart_product.toJSON())
                  respond(cp_update_err,updated_cart_product)
                  # mode to after callback
                  if trigger_pricing? and trigger_pricing == true
                    updated_cart_product.cart (err, cart_to_price)->
                      if err
                        console.error err.stack
                        socket.emit 'cart:pricing:error', 'No se pudo leer la orden actual'
                      else
                        cart_to_price.price(socket)

CartProduct.removeItem = (data, respond, socket) ->
  if data?
    CartProduct.find data.id, (cp_err, cart_product) ->
      if cp_err
        respond(cp_err)
      else
        if cart_product?
          cart_product.cart (err, cart) ->
            cart_product.destroy (del_err) ->
              if del_err?
                respond(del_err)
              else
                respond(del_err, data.id)
                cart.cart_products {}, (cp_list_err, cart_products) ->
                  if cp_list_err
                    console.erro cp_list_err.stack
                  else
                    if _.isEmpty(cart_products)
                      socket.emit 'cart:empty', {cart: cart}
                    else
                      cart.price(socket)

              


module.exports = CartProduct