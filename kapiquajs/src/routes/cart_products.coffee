Cart = require('../models/cart')
Product = require('../models/product')
CartProduct = require('../models/cart_product')
PulseBridge = require('../pulse_bridge/pulse_bridge')
OrderReply = require('../pulse_bridge/order_reply')
async = require('async')
_ = require('underscore')

class CartProducts
  
  
  @create: (data, respond, socket) =>
    CartProduct.add(data, respond, socket)

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
          cp.product (p_err, product)->
            json_cp = JSON.parse(JSON.stringify(cp))
            json_cp.product = JSON.parse(JSON.stringify(product))
            parsed_options(json_cp, cb)
            # cb(null, json_cp)
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
              # add hadling for pulse errors
              cart.updateAttributes { net_amount: Number(order_reply.netamount), tax_amount: Number(order_reply.taxamount), payment_amount: Number(order_reply.payment_amount), updated_at: new Date() }, (cart_update_err, updated_cart)->
                if cart_update_err
                  console.log cart_update_err
                  # create an error system for socket.id
                  socket.emit 'data_error', {type: 'db_error' , msg:JSON.stringify(cart_update_err)} if socket?
                else
                  updated_cart.cart_products {}, (uc_cp_err, updated_cart_cart_products)->
                    for order_item in order_reply.order_items
                      for cart_product in updated_cart_cart_products
                        if Number(cart_product.quantity) == Number(order_item.quantity) and _.find(results, (cp) -> cp.id == cart_product.id).product.productcode == order_item.code and order_item.options.join(',') == cart_product.options
                          cart_product.updateAttributes { priced_at: Number(order_item.priced_at) , updated_at: new Date() }, (cp_update_price_error, update_price_cart_product)->
                            if (cp_update_price_error) 
                              socket.emit 'data_error', {type: 'pulse_connection' , msg:JSON.stringify(cp_update_price_error)} if socket?
                            else
                              socket.emit 'item_price_sync', {item_id: update_price_cart_product.id, price: update_price_cart_product.priced_at} if socket?
                  socket.emit 'cart_price_sync', {net_amount: updated_cart.net_amount, tax_amount: updated_cart.tax_amount, payment_amount: updated_cart.payment_amount} if socket?              
              
parsed_options = (cart_product, callback) ->
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
          product_option = {quantity: Number(current_quantity), product: to_json(current_product), part: current_part}
          product_options.push product_option
      cart_product.product_options = product_options
      callback(null, cart_product)

to_json = (obj) ->
  JSON.parse(JSON.stringify(obj))
            
module.exports = CartProducts