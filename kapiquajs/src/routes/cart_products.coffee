CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
Product = require('../models/product')
async = require('async')
_ = require('underscore')


exports.create = (req, res) ->
  params = req.body
  console.log JSON.stringify params
  # CartProduct.all {where: {cart_id: params.cart, product_id: params.product_id, options: params.options }}, (cp_err, found) ->
  #   console.log found
  cart_product = new CartProduct({cart_id: params.cart, product_id: params.product.id, options: params.options, bind_id: params.bind_to, quantity: Number(params.quantity)})
  cart_product.save (err)->
    if (err)
      console.log cart_product.errors
      console.log err
      res.send cart_product.errors
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