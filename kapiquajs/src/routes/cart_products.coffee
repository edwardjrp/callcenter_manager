CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
Product = require('../models/product')
async = require('async')
_ = require('underscore')


exports.create = (req, res) ->
  params = req.body
  console.log "request = #{JSON.stringify(req.body)}"
  CartProduct.create {cart_id: params.cart, product_id: params.product_id, options: params.options, bind_to: params.bind_to}, (cp_err, cart_product) ->
    if cp_err?
      console.log cp_err
      res.send(cp_err)
    else
      Cart.find cart_product.cart_id, (c_err, cart) ->
        cart.cart_products {}, (c_cp_err, cart_products)->
          get_products = (cp, cb)->
            Product.find cp.product(), (p_err, product)->
              json_cp = JSON.stringify(cp)
              json_cp.product = JSON.stringify(product)
              cb(null, json_cp)
          async.map cart_products,get_products, (err, results)->
            json_cart = JSON.stringify(cart)
            json_cart.cart_products = results
            res.send(results)