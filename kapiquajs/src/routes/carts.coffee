Cart = require('../models/cart')
Product = require('../models/product')
Client = require('../models/client')
Store = require('../models/store')
CartProduct = require('../models/cart_product')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
async = require('async')
_ = require('underscore')

class Carts


  @price: (data, respond, socket) =>
    console.log data.cart_id
    Cart.find data.cart_id, (cart_find_err, cart)->
      if cart_find_err?
        socket.emit 'data_error', {type: 'error_recuperando datos de la orden' , msg:JSON.stringify(cart_find_err)} if socket?
      else
        cart.client (cart_client_err, client)->
          socket.emit 'cart:price:client', {client}
        console.log 'Princing'


  @place: (data, respond, socket) =>
    console.log 'Placing'


module.exports  = Carts