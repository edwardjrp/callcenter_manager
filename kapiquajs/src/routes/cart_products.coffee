CartProduct = require('../models/cart_product')
_ = require('underscore')
async = require('async')


exports.create = (req, res) ->
  params = req.body
  CartProduct.create {cart_id: params.cart, product_id: params.product_id, options: params.options, bind_to: params.bind_to}, (cp_err, cart_product) ->
    Cart.find cart_product.cart_id, (c_err, cart) ->
      cart.cart_products {}, (c_cp_err, cart_products)
        products = []
        _each cart_products, (cp)->
          cp.product (cp_p_error, product) ->
            products