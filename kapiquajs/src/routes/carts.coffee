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
    console.log 'Princing'


  @place: (data, respond, socket) =>
    console.log 'Placing'


module.exports  = Carts