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

  @status: (data, respond, socket) =>
    if data?
      Cart.find data, (cart_find_err, cart) ->
        if cart_find_err?
          console.error cart_find_err.stack
          socket.emit 'cart:status:error', 'La orden no se encontro en el sistema'
        else
          cart.status(socket) if cart?

  @price: (data, respond, socket, io) =>
    if data?
      Cart.find data, (cart_find_err, cart) ->
        if cart_find_err?
          console.error cart_find_err.stack
          socket.emit 'cart:price:error', 'La orden no se encontro en el sistema'
        else
          cart.price(socket, io) if cart?

  @place: (data, respond, socket, io) =>
    if data?
      Cart.find data.cart_id, (cart_find_err, cart) ->
        if cart_find_err?
          console.error cart_find_err.stack
          socket.emit 'cart:place:error', 'La orden no se encontro en el sistema'
        else
          cart.place(data, socket, io) if cart?

module.exports  = Carts