CartProduct = require('../models/cart_product')
Cart = require('../models/cart')
Product = require('../models/product')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
async = require('async')
_ = require('underscore')

class CartProducts
  
  
  @create: (data, respond, socket) =>
    search_hash = {cart_id: data.cart, product_id: data.product.id, options: data.options }
    search_hash['bind_id']= data.bind_id if data.bind_id? and typeof data.bind_id != undefined
    CartProduct.all {where: search_hash}, (cp_err, cart_products) ->
      if _.isEmpty(cart_products)
        cart_product = new CartProduct({cart_id: data.cart, product_id: data.product.id, options: data.options, bind_id: data.bind_id, quantity: Number(data.quantity), created_at: new Date()})
      else
        cart_product = _.first(cart_products)
        cart_product.quantity = cart_product.quantity + Number(data.quantity)
      CartProducts.save_item(cart_product, respond, socket)


  @update: (data, respond, socket) ->
    CartProduct.find data.id, (cp_err, cart_product) ->
      if cp_err?
        respond( {type:"error", data: 'El articulo no esta presente'})
      else
        cart_product.updateAttributes { options: data.options, quantity: Number(data.quantity), updated_at: new Date()}, (err)->
          if (err?)
             console.log cart_product.errors
             console.log err
             respond( {type:"error", data: (cart_product.errors || err)})
           else
             CartProducts.current_cart(cart_product.cart_id, respond , socket)

  @destroy: (data, respond, socket) ->
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
              CartProducts.current_cart(current_cart_id, respond, socket)
          

  @save_item: (cart_product, respond, socket)->
    cart_product.save (err)->
     if (err?)
       console.log cart_product.errors
       console.log err
       respond( {type:"error", data: (cart_product.errors || err)})
     else
       CartProducts.current_cart(cart_product.cart_id, respond, socket)           

  @current_cart: (cart_id, respond, socket)->
    Cart.find cart_id, (c_err, cart) ->
      cart.cart_products {}, (c_cp_err, cart_products)->
        get_products = (cp, cb)->
          Product.find cp.product(), (p_err, product)->
            json_cp = JSON.parse(JSON.stringify(cp))
            json_cp.product = JSON.parse(JSON.stringify(product))
            cb(null, json_cp)
        async.map cart_products,get_products, (it_err, results)->
          if it_err
            respond( {type:"error", data:it_err })
          else
            json_cart = JSON.parse(JSON.stringify(cart))
            json_cart.cart_products = results
            respond({type:"success", data: json_cart})
            
            socket.emit 'start_price_sync', {user: 'pulse ', msg: new Date(json_cart.updated_at)} if socket?
            
            pulse_com_error = (comm_err) ->
              console.log comm_err
              socket.emit 'data_error', {type: 'pulse_connection' , msg:JSON.stringify(comm_err)} if socket?
            PulseBridge.price json_cart, pulse_com_error, (res_data) ->
              order_reply = new OrderReply(res_data)
              cart.updateAttributes { net_amount: Number(order_reply.netamount), tax_amount: Number(order_reply.taxamount), payment_amount: Number(order_reply.payment_amount), updated_at: new Date() }, (cart_update_err, updated_cart)->
                if cart_update_err
                  console.log cart_update_err
                  # create an error system for socket.id
                  socket.emit 'data_error', {type: 'db_error' , msg:JSON.stringify(cart_update_err)} if socket?
                else
                  socket.emit 'done_price_sync', {user: 'pulse ', msg: new Date(updated_cart.updated_at)} if socket?
              socket.emit 'price', {user: 'pulse ', msg: order_reply} if socket?
              
              



            
module.exports = CartProducts