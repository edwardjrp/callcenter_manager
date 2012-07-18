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
        get_products = (cp, cb)->
          Product.find cp.product(), (p_err, product)->
            console.log product
            cb(null, product)
        async.map cart_products,get_products, (err, results)->
          console.log results
          res.send('done')