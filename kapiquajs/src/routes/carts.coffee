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
    Cart.find data.cart_id, (cart_find_err, cart) ->
      if cart_find_err?
        socket.emit 'cart:price:error', {error: JSON.stringify(cart_find_err)} if socket?
      else
        cart.client (cart_client_err, client) ->
          socket.emit 'cart:price:client', {client}
          if client.phones_count? and client.phones_count > 0
            client.phones (cart_client_phones_err, phones)->
              if cart_client_phones_err?
                socket.emit 'cart:price:error', {error: JSON.stringify(cart_client_phones_err)} if socket?
              else
                socket.emit 'cart:price:client:phones', {phones} if socket?

        cart.cart_products {}, (c_cp_err, cart_products)->
          get_products = (cp, cb)->
            cp.product (p_err, product)->
              json_cp = JSON.parse(JSON.stringify(cp))
              json_cp.product = JSON.parse(JSON.stringify(product))
              cb(null, json_cp)
          async.map cart_products,get_products, (it_err, results)->
            if it_err
              socket.emit 'cart:price:error', {error: JSON.stringify(it_err)} if socket?
            else
              socket.emit 'cart:price:cartproducts', {results} if socket?
              json_cart = JSON.parse(JSON.stringify(cart))
              json_cart.cart_products = results
              
              socket.emit 'cart:price:pulse:start', {} if socket?  
              
              pulse_com_error = (comm_err) ->
                console.log comm_err
                socket.emit 'cart:price:error', {error: JSON.stringify(comm_err)} if socket?
                
              PulseBridge.price json_cart, pulse_com_error, (res_data) ->
                order_reply = new OrderReply(res_data)
                # add hadling for pulse errors
                cart.updateAttributes { net_amount: Number(order_reply.netamount), tax_amount: Number(order_reply.taxamount), payment_amount: Number(order_reply.payment_amount), updated_at: new Date() }, (cart_update_err, updated_cart)->
                  if cart_update_err
                    console.log cart_update_err
                    # create an error system for socket.id
                    socket.emit 'cart:price:error', {error: JSON.stringify(comm_err)} if socket?
                  else
                    updated_cart.cart_products {}, (uc_cp_err, updated_cart_cart_products)->
                      for order_item in order_reply.order_items
                        for cart_product in updated_cart_cart_products
                          if Number(cart_product.quantity) == Number(order_item.quantity) and _.find(results, (cp) -> cp.id == cart_product.id).product.productcode == order_item.code and order_item.options.join(',') == cart_product.options
                            cart_product.updateAttributes { priced_at: Number(order_item.priced_at) , updated_at: new Date() }, (cp_update_price_error, update_price_cart_product)->
                              if (cp_update_price_error) 
                                socket.emit 'cart:price:error', {error: JSON.stringify(cp_update_price_error)} if socket?
                              else
                                socket.emit 'cart:price:pulse:itempriced', {item_id: update_price_cart_product.id, price: update_price_cart_product.priced_at} if socket?
                    socket.emit 'cart:price:pulse:cartpriced', {net_amount: updated_cart.net_amount, tax_amount: updated_cart.tax_amount, payment_amount: updated_cart.payment_amount} if socket?              
              
        console.log 'Princing'


  @place: (data, respond, socket) =>
    socket.emit 'cart:price:error', {error: 'La información requerida para colocar la orden no esta completa'} if socket?
    console.log 'Placing'


module.exports  = Carts




# if client.addresses_count? and client.addresses_count > 0
#   client.addresses (cart_client_addresses_err, addresses)->
#     if cart_client_addresses_err?
#       socket.emit 'cart:price:error', {error: JSON.stringify(cart_client_addresses_err)} if socket?
#     else
#       socket.emit 'cart:price:client:addresses', {addresses}
