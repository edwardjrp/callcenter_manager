Cart = require('./schema').Cart
async = require('async')
_ = require('underscore')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
Setting = require('../models/setting')
Cart.validatesPresenceOf('user_id')

# Cart.read = (data, respond, socket)->
#   id = data.id
#   Cart.find data.cart_id, (cart_find_err, cart) ->
#     if cart_find_err?
#       respond(cart_find_err)
#     else
#       console.log 'HELLO'
#       Cart.products data.id , (err, collection) ->
#         console.log err if err
#         console.log collection if collection

Cart.prototype.products = (cb)->
  Cart.schema.adapter.query "SELECT \"products\".* FROM \"products\" INNER JOIN \"cart_products\" ON \"products\".\"id\" = \"cart_products\".\"product_id\" WHERE \"cart_products\".\"cart_id\" = #{@id}", (err, collection) ->
    if (err)
      cb(err)
    else
      cb(err, collection)

Cart.prototype.price = (socket)->
  me = this
  async.waterfall [
    (callback) ->
      me.cart_products {}, (c_cp_err, cart_products) ->
        if(c_cp_err)
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden' if socket?
        else
          current_cart_products = _.map(cart_products, (cart_product)-> cart_product.simplified())
          callback(null, current_cart_products)
    ,
    (current_cart_products, callback) ->
      me.products (c_p_err, products) ->
        if(c_p_err)
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden' if socket?
        else
          updated_cart_products = _.map current_cart_products, (current_cart_product)-> 
            current_cart_product.product = _.find products, (product)->
              product.id == current_cart_product.product_id
          callback(null, current_cart_products, updated_cart_products)

    ]
    ,
    (final_error, updated_cart_products, current_cart_products) ->
      if final_error?
        console.log final_error
        socket.emit 'cart:price:error', 'Un error impidio solitar el precio de esta orden' if socket?  
      else
        current_cart  = me.simplified()
        current_cart.cart_products = updated_cart_products
        pulse_com_error = (comm_err) ->
          console.log comm_err
          socket.emit 'cart:price:error', {error: JSON.stringify(comm_err)} if socket?
        Setting.kapiqua (err, settings) ->
          if err
            console.error err
          else
            cart_request = new  PulseBridge(current_cart, settings.price_store_id, settings.price_store_ip,  settings.pulse_port)
            cart_request.price pulse_com_error, (res_data)->
              # order_reply = new OrderReply(res_data)              
              console.log res_data
        # PulseBridge.price current_cart, pulse_com_error, (res_data) ->

        #   order_reply = new OrderReply(res_data)
        #   console.log order_reply


Cart.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))

module.exports = Cart