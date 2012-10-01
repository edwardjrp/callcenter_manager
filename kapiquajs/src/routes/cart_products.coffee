Cart = require('../models/cart')
Product = require('../models/product')
CartProduct = require('../models/cart_product')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
async = require('async')
_ = require('underscore')

class CartProducts
  
  @create: (data, respond, socket) =>
    CartProduct.addItem(data, respond, socket)

  @update: (data, respond, socket) ->
    CartProduct.updateItem(data, respond, socket)

  @destroy: (data, respond, socket) ->
    CartProduct.removeItem(data, respond, socket)
            
module.exports = CartProducts