Cart = require('./schema').Cart
async = require('async')
_ = require('underscore')
Cart.validatesPresenceOf('user_id')


Cart.read = (data, respond, socket)->
  id = data.id
  Cart.find data.cart_id, (cart_find_err, cart) ->
    if cart_find_err?
      respond(cart_find_err)
    else
      console.log 'HELLO'
      Cart.products data.id , (err, collection) ->
        console.log err if err
        console.log collection if collection

Cart.products = (id, respond) ->
  Cart.command "SELECT \"products\".* FROM \"products\" INNER JOIN \"cart_products\" ON \"products\".\"id\" = \"cart_products\".\"product_id\" WHERE \"cart_products\".\"cart_id\" = #{id}", (err, collection) ->
    if (err)
      respond(err)  
    else
      respond(err, collection)  

module.exports = Cart