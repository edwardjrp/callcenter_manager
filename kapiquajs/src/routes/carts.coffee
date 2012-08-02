Cart = require('../models/cart')
Product = require('../models/product')
Client = require('../models/client')
Store = require('../models/store')
Phone = require('../models/phone')
Address = require('../models/address')
CartProduct = require('../models/cart_product')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
async = require('async')
_ = require('underscore')

class Carts

  @price: (data, respond, socket) =>
    Cart.find data.cart_id, (cart_find_err, cart) ->
      if cart_find_err?
        socket.emit 'cart:price:error', {error: JSON.stringify(cart_find_err)} if socket?
      else
        cart.client (cart_client_err, client) ->
          socket.emit 'cart:price:client', {client}
          if client.phones_count? and client.phones_count > 0
            client.phones (cart_client_phones_err, phones)->
              if cart_client_phones_err?
                socket.emit 'cart:price:error', {error: JSON.stringify(cart_client_phones_err)} if socket?
              else
                socket.emit 'cart:price:client:phones', {phones} if socket?

        cart.cart_products {}, (c_cp_err, cart_products)->
          get_products = (cp, cb)->
            cp.product (p_err, product)->
              json_cp = JSON.parse(JSON.stringify(cp))
              json_cp.product = JSON.parse(JSON.stringify(product))
              cb(null, json_cp)
          async.map cart_products,get_products, (it_err, results)->
            if it_err
              socket.emit 'cart:price:error', {error: JSON.stringify(cart_client_phones_err)} if socket?
            else
              socket.emit 'cart:price:client:cartproducts', {results} if socket?
              
        console.log 'Princing'


  @place: (data, respond, socket) =>
    console.log 'Placing'


module.exports  = Carts




# if client.addresses_count? and client.addresses_count > 0
#   client.addresses (cart_client_addresses_err, addresses)->
#     if cart_client_addresses_err?
#       socket.emit 'cart:price:error', {error: JSON.stringify(cart_client_addresses_err)} if socket?
#     else
#       socket.emit 'cart:price:client:addresses', {addresses}
