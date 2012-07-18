Config = require('../config')
jugglingdb = require('jugglingdb')
Schema = jugglingdb.Schema
DB = new Schema('postgres', { 'url': Config.connection_string })


CartProduct = DB.define("CartProduct",
  cart_id:
    type: Number

  product_id:
    type: Number

  quantity:
    type: Number

  options:
    type: String
    length: 255

  bind_to:
    type: Number

  created_at:
    type: Date
    default: Date.now

  updated:
    type: Date
    default: Date.now
,
  table: "cart_products"
)



exports.CartProduct = CartProduct;