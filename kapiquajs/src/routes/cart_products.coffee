CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
Product = require('../models/product')
async = require('async')
_ = require('underscore')


exports.create = (req, res) ->
  params = req.body
  console.log JSON.stringify params
  CartProduct.all {where: {cart_id: params.cart, product_id: params.product.id, options: params.options }}, (cp_err, cart_products) ->
    if _.isEmpty(cart_products)
      cart_product = new CartProduct({cart_id: params.cart, product_id: params.product.id, options: params.options, bind_id: params.bind_to, quantity: Number(params.quantity)})
    else
      cart_product = _.first(cart_products)
      cart_product.quantity = cart_product.quantity + Number(params.quantity)
    save_item(cart_product,  req, res)
            
          
          
save_item = (cart_product, req, res)->
  cart_product.save (err)->
   if (err)
     console.log cart_product.errors
     console.log err
     res.send cart_product.errors
   else
     current_cart(cart_product, req, res )           
            
current_cart = (cart_product, req, res)->
  Cart.find cart_product.cart_id, (c_err, cart) ->
    cart.cart_products {}, (c_cp_err, cart_products)->
      get_products = (cp, cb)->
        Product.find cp.product(), (p_err, product)->
          json_cp = JSON.parse(JSON.stringify(cp))
          json_cp.product = JSON.parse(JSON.stringify(product))
          cb(null, json_cp)
      async.map cart_products,get_products, (err, results)->
        json_cart = JSON.parse(JSON.stringify(cart))
        json_cart.cart_products = results
        res.send(json_cart)