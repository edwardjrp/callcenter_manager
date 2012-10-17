Cart = require('./schema').Cart
async = require('async')
_ = require('underscore')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
CartProduct = require('../models/cart_product')
Client = require('../models/client')
Store = require('../models/store')
Phone = require('../models/phone')
User = require('../models/user')
Address = require('../models/address')
Setting = require('../models/setting')

Cart.validatesPresenceOf('user_id')


Cart.prototype.products = (cb)->
  Cart.schema.adapter.query "SELECT \"products\".* FROM \"products\" INNER JOIN \"cart_products\" ON \"products\".\"id\" = \"cart_products\".\"product_id\" WHERE \"cart_products\".\"cart_id\" = #{@id}", (err, collection) ->
    if (err)
      console.error err.stack
      cb(err)
    else
      cb(err, collection)

Cart.prototype.price = (socket)->
  me = this
  async.waterfall [
    (callback) ->
      me.cart_products {}, (c_cp_err, cart_products) ->
        if (c_cp_err)
          console.error c_cp_err.stack
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden'
        else
          current_cart_products = _.map(cart_products, (cart_product)-> cart_product.simplified())
          callback(null, current_cart_products)
    ,
    (current_cart_products, callback) ->
      me.products (c_p_err, products) ->
        if(c_p_err)
          console.error c_p_err.stack
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
                  me.updatePrices(order_reply, socket) if order_reply.status == '0'  # mode emit into this function to emit after prices have been updated        
                  socket.emit 'cart:priced', {order_reply: order_reply, items: order_reply.products()}
                  console.info order_reply # update can_place_order
                  if order_reply.status == '6'
                    socket.emit('cart:coupons:autocomplete', current_cart_coupons)
              catch err_pricing
                console.error err_pricing.stack
        else
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden'



Cart.prototype.comm_failed = (socket) ->
  this.updateAttributes { communication_failed: true, message_mask: 9 } , (err, updated_cart) ->
    if err
      console.error err.stack
    else
      socket.emit 'cart:price:comm_failed', updated_cart


Cart.prototype.updatePrices = (order_reply, socket) ->
  # consider removing discount and exonerations
  this.updateAttributes {  can_place_order: order_reply.can_place, net_amount: order_reply.netamount, tax_amount: order_reply.taxamount, tax1_amount: order_reply.tax1amount, tax2_amount: order_reply.tax2amount,  payment_amount: order_reply.payment_amount } , (err, updated_cart) ->
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


Cart.prototype.place = (data, socket) ->
  me = this
  async.waterfall [
    (callback) ->
      me.cart_products {}, (c_cp_err, cart_products) ->
        if (c_cp_err)
          console.error c_cp_err.stack
          socket.emit 'cart:place:error', 'No se pudo acceder a la lista de productos para esta orden'
        else
          current_cart_products = _.map(cart_products, (cart_product)-> cart_product.simplified())
          callback(null, current_cart_products)
    ,
    (current_cart_products, callback) ->
      me.products (c_p_err, products) ->
        if(c_p_err)
          console.error c_p_err.stack
          socket.emit 'cart:place:error', 'No se pudo acceder a la lista de productos para esta orden'
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
          socket.emit 'cart:place:error', 'No se pudo acceder a la lista de cupones para esta orden'
        else
          current_cart_coupons = _.map(cart_coupons, (cart_coupon)-> cart_coupon.simplified())
          callback(null, current_cart_products, current_cart_coupons)
    ,
    (current_cart_products, current_cart_coupons, callback) ->
      me.client (cart_client_err, client) ->
        if(cart_client_err)
          console.error cart_client_err.stack
          socket.emit 'cart:place:error', 'No se pudo cargar el cliente para esta orden'
        else
          callback(null, current_cart_products, current_cart_coupons, client)
    ,
    (current_cart_products, current_cart_coupons, client, callback) ->
      me.user (cart_user_err, user) ->
        if(cart_user_err)
          console.error cart_user_err.stack
          socket.emit 'cart:place:error', 'No se pudo cargar el agente para esta orden'
        else
          callback(null, current_cart_products, current_cart_coupons, client, user)
    ,
    (current_cart_products, current_cart_coupons, client, user, callback) ->
      client.last_phone (l_p_err, phone) ->
        if l_p_err
          console.error l_p_err.stack
        else
          callback(null, current_cart_products, current_cart_coupons, client, user, phone)
    ,
    (current_cart_products, current_cart_coupons, client, user, phone, callback) ->
      client.last_address (l_a_err, address) ->
        if l_a_err
          console.error l_a_err.stack
        else
          callback(null, current_cart_products, current_cart_coupons, client, user, phone, address)
    ,
    (current_cart_products, current_cart_coupons, client, user, phone, address, callback) ->
      me.store (cart_store_err, store) ->
        if(cart_store_err)
          console.error cart_store_err.stack
          socket.emit 'cart:place:error', 'No se pudo acceder a la tienda para la esta orden'
        else
          callback(null, current_cart_products, current_cart_coupons, client, user, phone, address, store)
    ]
    ,
    (final_error,  current_cart_products, current_cart_coupons, client, user, phone, address, store) ->
      if final_error?
        console.error final_error.stack
        socket.emit 'cart:place:error', 'Un error impidio la colocación de la orden'
      else
        pulse_com_error = (comm_err) ->
          socket.emit 'cart:place:error', 'Falla en la comunicación con Pulse'
          me.comm_failed(socket)
          console.error comm_err.stack

        unless me.completed == true
          current_cart  = me.simplified()
          current_cart.cart_products = current_cart_products
          current_cart.cart_coupons = current_cart_coupons
          current_cart.client = client.simplified()
          console.log user
          current_cart.user = user.simplified()
          current_cart.phone = phone.simplified()
          current_cart.address = address.simplified()
          current_cart.store = store.simplified()
          current_cart.extra = data
          Setting.kapiqua (err, settings) ->
            if err
              socket.emit 'cart:place:error', 'Falla Lectura de la configuración'
              console.error err.stack
            else
              cart_request = new  PulseBridge(current_cart, current_cart.store.storeid, current_cart.store.ip,  settings.pulse_port)
              try
                cart_request.place pulse_com_error, (res_data)->
                  order_reply = new OrderReply(res_data)
                  console.log order_reply
                  if order_reply.status == '0'
                    me.updateAttributes { store_order_id: order_reply.order_id, complete_on: Date.now(), completed: true }, (cart_update_err, updated_cart)->
                      socket.emit 'cart:place:completed', updated_cart
                  else
                    socket.emit 'cart:place:error', "No se puede colocar la order, Pulse respondio: <br/> <strong>#{order_reply.status_text}</strong>"
              catch err_pricing
                socket.emit 'cart:place:error', 'Falla en la comunicación con Pulse'
                me.comm_failed(socket)
                console.error err_pricing.stack
        else
          socket.emit 'cart:place:error', 'Esta orden aparece como completada en el sistema'
          
            

Cart.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))

module.exports = Cart