Cart = require('./schema').Cart
async = require('async')
_ = require('underscore')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
CartProduct = require('../models/cart_product')
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
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden'
        else
          current_cart_products = _.map(cart_products, (cart_product)-> cart_product.simplified())
          callback(null, current_cart_products)
    ,
    (current_cart_products, callback) ->
      me.products (c_p_err, products) ->
        if(c_p_err)
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden'
        else
          _.each current_cart_products, (current_cart_product)-> 
            current_cart_product.product = _.find products, (product)->
              product.id == current_cart_product.product_id
          callback(null, current_cart_products)
    ,
    (current_cart_products, callback) ->
      me.cart_coupons (c_c_err, cart_coupons) ->
        if(c_c_err)
          console.error c_c_err.stack
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de cupones para esta orden'
        else
          current_cart_coupons = _.map(cart_coupons, (cart_coupon)-> cart_coupon.simplified())
          callback(null, current_cart_products, current_cart_coupons)
    ]
    ,
    (final_error,  current_cart_products, current_cart_coupons) ->
      if final_error?
        console.error final_error.stack
        socket.emit 'cart:price:error', 'Un error impidio solitar el precio de esta orden'
      else
        current_cart  = me.simplified()
        current_cart.cart_products = current_cart_products
        current_cart.cart_coupons = current_cart_coupons
        pulse_com_error = (comm_err) ->
          socket.emit 'cart:price:error', 'Un error de comunicación impidio solitar el precio de esta orden, la aplicacion no podra funcionar correctamente en este estado'
        if current_cart_products.length > 0
          Setting.kapiqua (err, settings) ->
            if err
              console.error err.stack
            else
              cart_request = new  PulseBridge(current_cart, settings.price_store_id, settings.price_store_ip,  settings.pulse_port)
              try
                cart_request.price pulse_com_error, (res_data)->
                  order_reply = new OrderReply(res_data, current_cart_products)
                  me.updatePrices(order_reply, socket)   # mode emit into this function to emit after prices have been updated        
                  socket.emit 'cart:priced', {order_reply: order_reply, items: order_reply.products()}
              catch err_pricing
                console.error err_pricing.stack
        else
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden'




Cart.prototype.updatePrices = (order_reply, socket) ->
  this.updateAttributes { net_amount: order_reply.netamount, tax_amount: order_reply.taxamount, tax1_amount: order_reply.tax1amount, tax2_amount: order_reply.tax2amount,  payment_amount: order_reply.payment_amount } , (err, updated_cart) ->
    if err
      console.error err.stack
      socket.emit 'cart:price:error', 'No se pudo actualizar los precios en la base de datos'
    else
      _.each order_reply.products(), (pricing) ->
        CartProduct.find pricing.cart_product_id , (cp_err, cart_product)->
          unless cp_err
            cart_product.updateAttributes { priced_at: pricing.priced_at}, (update_err, updated_cart_product) ->
              if update_err
                console.error update_err




Cart.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))

module.exports = Cart