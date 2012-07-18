CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
Product = require('../models/product')
async = require('async')
_ = require('underscore')


exports.create = (req, res) ->
  params = req.body
  CartProduct.create {cart_id: params.cart, product_id: params.product_id, options: params.options, bind_to: params.bind_to}, (cp_err, cart_product) ->
    Cart.find cart_product.cart_id, (c_err, cart) ->
      cart.cart_products {}, (c_cp_err, cart_products)->
        products = []
        _.each cart_products, (cp)->
          Product.find cp.product(), (p_err, product) ->
            products.push product
        res.send('done')