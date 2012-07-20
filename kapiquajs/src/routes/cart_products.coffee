CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
Product = require('../models/product')
async = require('async')
_ = require('underscore')

exports.create = (data, respond) ->
  CartProduct.all {where: {cart_id: data.cart, product_id: data.product.id, options: data.options }}, (cp_err, cart_products) ->
    if _.isEmpty(cart_products)
      cart_product = new CartProduct({cart_id: data.cart, product_id: data.product.id, options: data.options, bind_id: data.bind_id, quantity: Number(data.quantity)})
    else
      cart_product = _.first(cart_products)
      cart_product.quantity = cart_product.quantity + Number(data.quantity)
    save_item(cart_product,  data, respond)





exports.destroy = (data, respond) ->
  current_cart_id = data.cart
  if current_cart_id?
    CartProduct.all {where: {cart_id: data.cart, product_id: data.product.id, options: data.options }}, (cp_err, cart_products) ->
      if _.isEmpty(cart_products)
        respond( {type:"error", data: 'El articulo no esta presente'})
      else  
        cart_product_to_delete = _.first(cart_products)
        cart_product_to_delete.destroy (del_err) ->
          if del_err?
            console.log cart_product_to_delete.errors
            console.log del_err
            respond( {type:"error", data: (cart_product_to_delete.errors || del_err)})
          else
            current_cart(current_cart_id, data, respond)
          
save_item = (cart_product, data, respond)->
  cart_product.save (err)->
   if (err?)
     console.log cart_product.errors
     console.log err
     respond( {type:"error", data: (cart_product.errors || err)})
   else
     current_cart(cart_product.cart_id, data, respond )           
            
current_cart = (cart_id, data, respond)->
  Cart.find cart_id, (c_err, cart) ->
    cart.cart_products {}, (c_cp_err, cart_products)->
      get_products = (cp, cb)->
        Product.find cp.product(), (p_err, product)->
          json_cp = JSON.parse(JSON.stringify(cp))
          json_cp.product = JSON.parse(JSON.stringify(product))
          cb(null, json_cp)
      async.map cart_products,get_products, (err, results)->
        if err
          respond( {type:"error", data:err })
        else
          json_cart = JSON.parse(JSON.stringify(cart))
          json_cart.cart_products = results
          respond({type:"success", data: json_cart})