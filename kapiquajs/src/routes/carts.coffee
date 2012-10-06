Cart = require('../models/cart')
Product = require('../models/product')
Client = require('../models/client')
Store = require('../models/store')
Phone = require('../models/phone')
Address = require('../models/address')
CartProduct = require('../models/cart_product')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
async = require('async')
_ = require('underscore')

class Carts

  @price: (data, respond, socket) =>
    if data?
      Cart.find data, (cart_find_err, cart) ->
        if cart_find_err?
          socket.emit 'cart:price:error', 'No se pudo establecer la comunición con pulse' if socket?
        else
          cart.price(socket)

  @place: (data, respond, socket) =>
    # socket.emit 'cart:price:error', {error: 'La información requerida para colocar la orden no esta completa'} if socket?
    Cart.find data, (cart_find_err, cart) ->
      if cart_find_err?
        console.error cart_find_err.stack
        socket.emit 'cart:place:error', {error: JSON.stringify(cart_find_err)} if socket?
      else
        async.waterfall [
          (callback) ->
            cart.client (cart_client_err, client) ->
              if(cart_client_err)
                socket.emit 'cart:place:error', {error: JSON.stringify(cart_client_err)} if socket?  
              else
                callback(null, client)
          ,
          (client, callback) ->
            cart.cart_products {}, (c_cp_err, cart_products) ->
              if(c_cp_err)
                socket.emit 'cart:place:error', {error: JSON.stringify(c_cp_err)} if socket?
              else
                get_products = (cp, cb) ->
                  cp.product (p_err, product) ->
                    jcp = Carts.to_json(cp)
                    jcp.product = Carts.to_json(product)
                    Carts.parsed_options(jcp, cb)
                    
                async.map cart_products,get_products, (it_err, cart_products) ->
                  if it_err
                    socket.emit 'cart:place:error', {error: JSON.stringify(it_err)} if socket?
                  else
                    callback(null, client, cart_products)
          ,
          ( client, cart_products, callback ) ->
            if client.phones_count? and client.phones_count > 0
              client.phones (cart_client_phones_err, phones) ->
                if cart_client_phones_err?
                  socket.emit 'cart:place:error', {error: JSON.stringify(cart_client_phones_err)} if socket?
                else
                  callback(null, client, cart_products, Carts.to_json(phones))
            else
              callback(null, client, cart_products, [])
          ,
          (client, cart_products, phones, callback) ->
            if client.addresses_count? and client.addresses_count > 0
              client.addresses (cart_client_addresses_err, addresses) ->
                if cart_client_addresses_err?
                  socket.emit 'cart:place:error', {error: JSON.stringify(cart_client_addresses_err)} if socket?
                else
                  callback(null, client, cart_products, phones, Carts.to_json(addresses))
            else
              callback(null, client, cart_products, phones, [])
          ,
          (client, cart_products , phones, addresses, callback) ->
            cart.store (cart_store_err, store) ->
              if(cart_store_err)
                socket.emit 'cart:place:error', {error: JSON.stringify(cart_store_err)} if socket?  
              else
                callback(null, client, cart_products , phones, addresses, Carts.to_json(store))
        ]
        ,
        (final_error,  client, cart_products, phones, addresses, store) ->
          if final_error?
            console.log 'Error at the end'
            # socket.emit 'cart:place:error', {error: ''} if socket?  
          else
            pulse_com_error = (comm_err) ->
              # emit an error
              console.log comm_err
            # check all user elemenents
            # include user in assembled cart
            unless cart.completed == true
              assempled_cart = Carts.to_json(cart)
              assempled_cart.client = client
              assempled_cart.cart_products = cart_products
              assempled_cart.phones = phones
              assempled_cart.addresses = addresses
              assempled_cart.store = store
              # console.log assempled_cart
              if assempled_cart.store? and assempled_cart.client? and assempled_cart.cart_products.length > 0 and assempled_cart.phones.length > 0
                # stablish send time to avoid sending for the next 30 seconds or so
                try
                  console.log 'dont forget to pull port from settings'
                  cart_placer = new PulseBridge(assempled_cart, assempled_cart.store.storeid, assempled_cart.store.ip, '59101')
                  cart_placer.place pulse_com_error, (res_data) ->
                    # console.log res_data
                    order_reply = new OrderReply(res_data)
                    console.log order_reply
                    # if order_reply.status == '0'
                    #   cart.updateAttributes { store_order_id: order_reply.reply_id, completed: true }, (cart_update_err, updated_cart)->
                    #     console.log updated_cart
                    # else
                    #   console.log "Notify of the pulse response here : #{order_reply.status_text}"
                catch placing_error
                  console.error placing_error.stack
              else
                console.log 'Princing conditions not met'
            else
              # here emits cart completer errot
              console.log 'Cart is complete'


      # console.log 'Placing'

  @to_json : (obj) ->
    JSON.parse(JSON.stringify(obj))


  @parsed_options : (cart_product, callback) ->
    return [] if cart_product.product.options == '' and cart_product.options == ''
    product_options = []
    recipe = cart_product.options || cart_product.product.options
    current_category_id = cart_product.product.category_id
    Product.all {where: {category_id: current_category_id, options: 'OPTION'}}, (cat_options_products_err, cat_options_products)->
      if _.any(recipe.split(','))
        _.each _.compact(recipe.split(',')), (code) ->
          code_match = code.match(/^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/)
          if code_match?
            code_match[1] = '1' if not code_match[1]? or code_match[1] == ''
            current_quantity = code_match[1]
            current_product = _.find(cat_options_products, (op)-> op.productcode == code_match[2])
            current_part =  code_match[3] || 'W'
            product_option = {quantity: Number(current_quantity), product: Carts.to_json(current_product), part: current_part}
            product_options.push product_option
        cart_product.product_options = product_options
        callback(null, cart_product)

module.exports  = Carts




# if client.addresses_count? and client.addresses_count > 0
#   client.addresses (cart_client_addresses_err, addresses)->
#     if cart_client_addresses_err?
#       socket.emit 'cart:price:error', {error: JSON.stringify(cart_client_addresses_err)} if socket?
#     else
#       socket.emit 'cart:price:client:addresses', {addresses}
