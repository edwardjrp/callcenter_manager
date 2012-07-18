CartProduct = require('../models/cart_product')

exports.create = (req, res) ->
  CartProduct.find 1, (err, cart_product) ->
   console.log cart_product
   res.send(cart_product)