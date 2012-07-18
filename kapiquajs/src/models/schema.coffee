Config = require('../config')
jugglingdb = require('jugglingdb')
Schema = jugglingdb.Schema
DB = new Schema('postgres', { 'url': Config.connection_string })


Cart = DB.define("Cart",
  user_id:
    type: Number

  client_id:
    type: Number

  communication_failed:
    type: Boolean

  status_text:
    type: String
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
    type: String
    length: 255
,
  table: "categories"
)
    
Product = DB.define("Product",
  category_id:
    type: Number

  productcode:
    type: String
    length: 255

  productname:
    type: String
    length: 255

  options:
    type: String
    length: 255

  sizecode:
    type: String
    length: 255

  flavorcode:
    type: String
    length: 255

  optionselectiongrouptype:
    type: String
    length: 255

  productoptionselectiongroup:
    type: String
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
Cart.hasMany(CartProduct, {as: 'cart_products', foreignKey: 'cart_id'})
Category.hasMany(Product, {as: 'products', foreignKey: 'category_id'})
Product.hasMany(CartProduct, {as: 'cart_products', foreignKey: 'product_id'})
CartProduct.belongsTo(Product, {as: 'product', foreignKey: 'product_id'})
CartProduct.belongsTo(Cart, {as: 'cart', foreignKey: 'cart_id'})


exports.CartProduct = CartProduct
exports.Cart = Cart
exports.Product = Product
exports.Category = Category