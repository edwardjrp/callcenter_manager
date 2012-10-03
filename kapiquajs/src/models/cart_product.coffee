CartProduct = require('./schema').CartProduct
async = require('async')
_ = require('underscore')
CartProduct.validatesPresenceOf('cart_id')
CartProduct.validatesPresenceOf('product_id')
CartProduct.validatesPresenceOf('quantity')
CartProduct.validatesNumericalityOf('quantity')


CartProduct.addItem = (data, respond, socket) ->
  if data?
    search_hash = {cart_id: data.cart, product_id: data.product.id, options: data.options }
    CartProduct.all {where: search_hash}, (cp_err, cart_products) ->
      if _.isEmpty(cart_products)
        cart_product = new CartProduct({cart_id: data.cart, product_id: data.product.id, options: data.options, bind_id: data.bind_id, quantity: Number(data.quantity), created_at: new Date()})
        cart_product.save (err, result_cart_product) ->
          if (err)
            respond(err)
          else
            result_cart_product.cart (err, cart) ->
              socket.emit('cart_products:saved', cart.toJSON())
            respond(err, result_cart_product)
      else
        cart_product = _.first(cart_products)
        cart_product.updateAttributes { quantity: (cart_product.quantity + Number(data.quantity)), options: data.options, updated_at: new Date()}, (err, updated_cart_product)->
          if err?
             respond(err)
           else
              socket.emit('cart_products:updated', updated_cart_product.toJSON())
              respond(err,updated_cart_product)

CartProduct.updateItem =  (data, respond, socket, trigger_pricing) ->
  if data?
    CartProduct.find data.id, (cp_err, cart_product) ->
        if cp_err?
          respond(err)
        else
          if cart_product?
            cart_product.updateAttributes { quantity: Number(data.quantity), options: data.options, updated_at: new Date()}, (err, updated_cart_product)->
              if err?
                 respond(err)
               else
                  socket.emit('cart_products:updated', updated_cart_product.toJSON())
                  respond(err,updated_cart_product)
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
              socket.emit('cart_products:deleted', data.id)
              
CartProduct.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))



module.exports = CartProduct