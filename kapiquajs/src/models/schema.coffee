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

  store_order_id:
    type: String
    length: 255


  business_date:
    type: Date

  advance_order_time:
    type: Date

  net_amount:
    type: Number

  tax_amount:
    type: Number

  tax1_amount:
    type: Number

  tax2_amount:
    type: Number

  payment_amount:
    type: Number

  message:
    type: String
    length: 255

  order_text:
    type: String
    length: 255

  order_progress:
    type: String
    length: 255

  can_place_order:
    type: Boolean

  delivery_instructions:
    type: Schema.Text

  payment_type:
    type: String
    length: 255

  credit_cart_approval_name:
    type: String
    length: 255

  fiscal_number:
    type: String
    length: 255

  fiscal_type:
    type: String
    length: 255

  company_name:
    type: String
    length: 255

  discount:
    type: Number

  discount_auth_id:
    type: Number

  completed:
    type: Boolean
    default: false

  created_at:
    type: Date
    default: Date.now

  updated_at:
    type: Date
    default: Date.now
,
  table: "carts"
)

Category = DB.define("Category",
  name:
    type: String
    length: 255
    
  created_at:
    type: Date
    default: Date.now

  updated_at:
    type: Date
    default: Date.now
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

  updated_at:
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

  bind_id:
    type: Number

  created_at:
    type: Date
    default: Date.now

  updated_at:
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