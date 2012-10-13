CartProduct = require('./schema').CartProduct
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
        result_cart_product.cart (c_err, cart) ->
          if c_err
            socket.emit 'cart:pricing:error', 'No se pudo leer la orden actual'
          else
            cart.price(socket)
        respond(err, result_cart_product)
    

CartProduct.updateItem =  (data, respond, socket, trigger_pricing) ->
  console.log data
  if data?
    CartProduct.find data.id, (cp_err, cart_product) ->
        if cp_err?
          respond(cp_err)
        else
          if cart_product?
            attributes = {}
            attributes['quantity'] = Number(data.quantity) if data? and data.quantity?
            attributes['options'] = data.options if data? and data.options?
            attributes['updated_at'] = new Date()
            console.log attributes
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
                        socket.emit 'cart:pricing:error', 'No se pudo leer la orden actual'
                      else
                        cart_to_price.price(socket)

CartProduct.removeItem = (data, respond, socket) ->
  if data?
    CartProduct.find data.id, (cp_err, cart_product) ->
      if cp_err
        respond(cp_err)
      else 
        cart_product.cart (err, cart) ->
          cart_product.destroy (del_err) ->
            if del_err?
              respond(del_err)
            else
              respond(del_err, data.id)
              cart.price(socket)
              
CartProduct.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))



module.exports = CartProduct