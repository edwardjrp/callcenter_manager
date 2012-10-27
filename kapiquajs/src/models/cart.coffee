Cart = require('./schema').Cart
async = require('async')
_ = require('underscore')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
CartProduct = require('../models/cart_product')
Client = require('../models/client')
Store = require('../models/store')
libxmljs = require("libxmljs")
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

Cart.prototype.status = (socket)->
  me = this
  if me.completed == true and me.store_order_id? and me.store_order_i isnt ''
    me.store (cart_store_err, store) ->
        if(cart_store_err)
          console.error cart_store_err.stack
          socket.emit 'cart:place:error', 'No se pudo acceder a la tienda para la esta orden'
        else
          Setting.kapiqua (err, settings) ->
            if err
              console.error err.stack
            else
              pulse_com_error = (comm_err) ->
                socket.emit 'cart:status:error', 'Un error impidio solicitar el status de la orden a pulse'
              cart_request = new  PulseBridge(me.toJSON(), store.storeid, store.ip,  settings.pulse_port)
              cart_request.status pulse_com_error, (res_data)->
                if res_data?
                  doc = libxmljs.parseXmlString(res_data)
                  if doc.get('//OrderProgress')?
                    me.updateAttributes { order_progress: doc.get('//OrderProgress').text() }, (cart_update_error, updated_cart) ->
                      if cart_update_error 
                        console.error cart_update_error.stack
                      else
                        socket.emit 'cart:status:pulse', { updated_cart }




Cart.prototype.price = (socket)->
  me = this
  async.waterfall [
    (callback) ->
      me.cart_products {}, (c_cp_err, cart_products) ->
        if (c_cp_err)
          console.error c_cp_err.stack
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden'
        else
          current_cart_products = _.map(cart_products, (cart_product)-> cart_product.toJSON())
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
          current_cart_coupons = _.map(cart_coupons, (cart_coupon)-> cart_coupon.toJSON())
          callback(null, current_cart_products, current_cart_coupons)
    ]
    ,
    (final_error,  current_cart_products, current_cart_coupons) ->
      if final_error?
        console.error final_error.stack
        socket.emit 'cart:price:error', 'Un error impidio solitar el precio de esta orden'
      else
        current_cart  = me.toJSON()
        current_cart.cart_products = current_cart_products
        current_cart.cart_coupons = current_cart_coupons
        
        if current_cart_products.length > 0
          Setting.kapiqua (err, settings) ->
            if err
              console.error err.stack
            else
              pulse_com_error = (comm_err) ->
                socket.emit 'cart:price:error', 'Un error de comunicación impidio solitar el precio de esta orden, la aplicacion no podra funcionar correctamente en este estado'
              cart_request = new  PulseBridge(current_cart, settings.price_store_id, settings.price_store_ip,  settings.pulse_port)
              try
                cart_request.price pulse_com_error, (res_data)->
                  order_reply = new OrderReply(res_data, current_cart_products)
                  me.updatePrices(order_reply, socket) if order_reply.status == '0'  # mode emit into this function to emit after prices have been updated        
                  socket.emit 'cart:priced', {order_reply: order_reply, items: order_reply.products()}
                  console.info order_reply # update can_place_order
                  if order_reply.status == '6'
                    socket.emit('cart:price:error', 'La orden tiene cupones incompletos')
              catch err_pricing
                socket.emit 'cart:price:error', 'Un error impidio solitar el precio de esta orden'
                console.error err_pricing.stack
        else
          socket.emit 'cart:price:error', 'No se pudo acceder a la lista de productos para esta orden'



Cart.prototype.comm_failed = (socket) ->
  this.updateAttributes { communication_failed: true, message_mask: 9 } , (err, updated_cart) ->
    if err
      console.error err.stack
    else
      socket.emit 'cart:place:comm_failed', updated_cart


Cart.prototype.updatePrices = (order_reply, socket) ->
  # consider removing discount and exonerations
  prices_attributes = {}
  prices_attributes['can_place_order'] = order_reply.can_place
  prices_attributes['net_amount'] = order_reply.netamount
  prices_attributes['tax_amount'] = order_reply.taxamount
  prices_attributes['tax1_amount'] = order_reply.tax1amount
  prices_attributes['tax2_amount'] = order_reply.tax2amount
  prices_attributes['payment_amount'] = order_reply.payment_amount
  prices_attributes['discount'] = 0.0
  prices_attributes['discount_auth_id'] = null
  prices_attributes['exonerated'] = false
  prices_attributes['exoneration_authorizer'] = null
  this.updateAttributes prices_attributes , (err, updated_cart) ->
    if err
      console.error err.stack
      socket.emit 'cart:price:error', 'No se pudo actualizar los precios en la base de datos'
    else
      _.each order_reply.products(), (pricing) ->
        CartProduct.find pricing.cart_product_id , (cp_err, cart_product)->
          unless cp_err?
            if cart_product?
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
          current_cart_products = _.map(cart_products, (cart_product)-> cart_product.toJSON())
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
          current_cart_coupons = _.map(cart_coupons, (cart_coupon)-> cart_coupon.toJSON())
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
        

        unless me.completed == true
          current_cart  = me.toJSON()
          current_cart.cart_products = current_cart_products
          current_cart.cart_coupons = current_cart_coupons
          current_cart.client = client.toJSON()
          current_cart.user = user.toJSON()
          current_cart.phone = phone.toJSON()
          current_cart.address = address?.toJSON()
          current_cart.store = store.toJSON()
          current_cart.extra = data
          payment_attributes = {}
          payment_attributes['payment_type'] = current_cart.extra?.payment_type || null
          payment_attributes['creditcard_number'] = current_cart.extra?.cardnumber || null
          payment_attributes['credit_card_approval_number'] = current_cart.extra?.cardapproval || null
          payment_attributes['fiscal_type'] = current_cart.extra?.fiscal_type || null
          payment_attributes['fiscal_number'] = current_cart.extra?.rnc || null
          payment_attributes['fiscal_company_name'] = current_cart.extra?.fiscal_name || null

          console.log payment_attributes
          me.updateAttributes payment_attributes, (pay_error, cart_with_pay_detailes) ->
            if (pay_error)
              console.error pay_error.stack
              socket.emit 'cart:place:error', 'No fue posible actualizar los datos de pago'
            else
              Setting.kapiqua (err, settings) ->
                if err
                  socket.emit 'cart:place:error', 'Falla Lectura de la configuración'
                  console.error err.stack
                else
                  pulse_com_error = (comm_err) ->
                    socket.emit 'cart:place:error', 'Falla en la comunicación con Pulse'
                    me.comm_failed(socket)
                    console.error comm_err.stack
                  cart_request = new  PulseBridge(current_cart, current_cart.store.storeid, current_cart.store.ip,  settings.pulse_port)
                  try
                    cart_request.place pulse_com_error, (res_data)->
                      console.info res_data
                      order_reply = new OrderReply(res_data)
                      console.info order_reply
                      if order_reply.status == '0'
                        me.updateAttributes { store_order_id: order_reply.order_id, complete_on: Date.now(), completed: true, message_mask: 1 }, (cart_update_err, updated_cart)->
                          socket.emit 'cart:place:completed', updated_cart
                      else
                        if order_reply and order_reply.status_text then msg = order_reply.status_text else msg = 'La respuesta e pulse no pudo ser interpretada'
                        socket.emit 'cart:place:error', "No se puede colocar la order, Pulse respondio: <br/> <strong>#{msg}</strong>"
                  catch err_pricing
                    socket.emit 'cart:place:error', 'Falla en la comunicación con Pulse'
                    me.comm_failed(socket)
                    console.error err_pricing.stack
        else
          socket.emit 'cart:place:error', 'Esta orden aparece como completada en el sistema'
          

module.exports = Cart