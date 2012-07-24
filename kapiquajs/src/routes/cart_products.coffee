CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
Product = require('../models/product')
PulseBridge = require('../pulse_bridge/pulse_bridge')
async = require('async')
_ = require('underscore')

class CartProducts
  
  this.socket = null
  
  @create: (data, respond) =>
    @socket.emit 'chat', {user: 'pulse ', msg: 'HELLO BEFORE FETCHING FROM PULSE'} if @socket?
    CartProduct.all {where: {cart_id: data.cart, product_id: data.product.id, options: data.options }}, (cp_err, cart_products) ->
      if _.isEmpty(cart_products)
        cart_product = new CartProduct({cart_id: data.cart, product_id: data.product.id, options: data.options, bind_id: data.bind_id, quantity: Number(data.quantity)})
      else
        cart_product = _.first(cart_products)
        cart_product.quantity = cart_product.quantity + Number(data.quantity)
      CartProducts.save_item(cart_product,  data, respond)


  @update: (data, respond) ->
    CartProduct.find data.id, (cp_err, cart_product) ->
      if cp_err?
        respond( {type:"error", data: 'El articulo no esta presente'})
      else
        cart_product.updateAttributes { options: data.options, quantity: Number(data.quantity)}, (err)->
          if (err?)
             console.log cart_product.errors
             console.log err
             respond( {type:"error", data: (cart_product.errors || err)})
           else
             CartProducts.current_cart(cart_product.cart_id, data, respond )

  @destroy: (data, respond) ->
    current_cart_id = data.cart
    if current_cart_id?
      CartProduct.find data.id, (cp_err, cart_product) ->
        if cp_err
          respond( {type:"error", data: 'El articulo no esta presente'})
        else  
          cart_product.destroy (del_err) ->
            if del_err?
              console.log cart_product.errors
              console.log del_err
              respond( {type:"error", data: (cart_product.errors || del_err)})
            else
              CartProducts.current_cart(current_cart_id, data, respond)
          

  @save_item: (cart_product, data, respond)->
    cart_product.save (err)->
     if (err?)
       console.log cart_product.errors
       console.log err
       respond( {type:"error", data: (cart_product.errors || err)})
     else
       CartProducts.current_cart(cart_product.cart_id, data, respond )           

  @current_cart: (cart_id, data, respond)->
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
            PulseBridge.send 'TestConnection','<Value>Hello there</Value>', null, (res_data) ->
              CartProducts.socket.emit 'chat', {user: 'pulse ', msg: res_data} if CartProducts.socket?
            respond({type:"success", data: json_cart})



            
module.exports = CartProducts