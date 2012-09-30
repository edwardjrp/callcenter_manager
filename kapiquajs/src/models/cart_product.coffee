CartProduct = require('./schema').CartProduct
Option = require('./option')
async = require('async')
_ = require('underscore')
CartProduct.validatesPresenceOf('cart_id')
CartProduct.validatesPresenceOf('product_id')
CartProduct.validatesPresenceOf('quantity')
CartProduct.validatesNumericalityOf('quantity')


CartProduct.add = (data, respond, socket) ->
  options = Option.pulseCollection(data.options)
  search_hash = {cart_id: data.cart, product_id: data.product.id, options: options }
  CartProduct.all {where: search_hash}, (cp_err, cart_products) ->
    if _.isEmpty(cart_products)
      cart_product = new CartProduct({cart_id: data.cart, product_id: data.product.id, options: '', bind_id: data.bind_id, quantity: Number(data.quantity), created_at: new Date()})
    else
      cart_product = _.first(cart_products)
      cart_product.quantity = cart_product.quantity + Number(data.quantity)
    cart_product.save (err, model) ->
      if (err)
        respond(err)
      else
        respond(err, model)

module.exports = CartProduct