CartProduct = require('../models/cart_product')


class CartProducts
  
  @create: (data, respond, socket) =>
    CartProduct.addItem(data, respond, socket, true)

  @addCollection: (data, respond, socket) ->
    CartProduct.addCollection(data, respond, socket, true)

  @update: (data, respond, socket) ->
    CartProduct.updateItem(data, respond, socket, true)

  @destroy: (data, respond, socket) ->
    CartProduct.removeItem(data, respond, socket, true)
            
module.exports = CartProducts