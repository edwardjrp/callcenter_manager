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

Cart = DB.define("Cart",
  user_id:
    type: Number

  client_id:
    type: Number

  communication_failed:
    type: Boolean

  status_text:
    type: status_text
    length: 255

  store_id:
    type: Number

  created_at:
    type: Date
    default: Date.now

  updated:
    type: Date
    default: Date.now
,
  table: "carts"
)

Category = DB.define("Category",
  name:
    type: status_text
    length: 255
,
  table: "categories"
)
    
Product = DB.define("Product",
  category_id:
    type: Number

  productcode:
    type: status_text
    length: 255

  productname:
    type: status_text
    length: 255

  options:
    type: status_text
    length: 255

  sizecode:
    type: status_text
    length: 255

  flavorcode:
    type: status_text
    length: 255

  optionselectiongrouptype:
    type: status_text
    length: 255

  productoptionselectiongroup:
    type: status_text
    length: 255
    
  created_at:
    type: Date
    default: Date.now

  updated:
    type: Date
    default: Date.now
,
  table: "products"
)

exports.CartProduct = CartProduct
exports.Cart = Cart
exports.Product = Product
exports.Category = Category