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
Client = DB.define("Client",

  first_name:
    type: String
    length: 255

  last_name:
    type: String
    length: 255

  email:
    type: String
    length: 255    

  idnumber:
    type: String
    length: 255    

  target_address_id:
    type: Number

  target_phone_id:
    type: Number

  phones_count:
    type: Number

  addresses_count:
    type: Number

  active:
    type: Boolean
    default: true

  created_at:
    type: Date
    default: Date.now

  updated_at:
    type: Date
    default: Date.now
,
  table: "clients"
)

User = DB.define("User",

  username:
    type: String
    length: 255    

  first_name:
    type: String
    length: 255

  last_name:
    type: String
    length: 255

  auth_token:
    type: String
    length: 255    

  password_digest:
    type: String
    length: 255    

  role_mask:
    type: Number   

  last_action_at:
    type: Date
    default: Date.now    

  login_count:
    type: Number   

  carts_count:
    type: Number   

  idnumber:
    type: String
    length: 255    

  active:
    type: Boolean
    default: true    


  created_at:
    type: Date
    default: Date.now

  updated_at:
    type: Date
    default: Date.now
,
  table: "users"
)
Phone = DB.define("Phone",

  number:
    type: String
    length: 255    

  ext:
    type: String
    length: 255


  client_id:
    type: Number   


  created_at:
    type: Date
    default: Date.now

  updated_at:
    type: Date
    default: Date.now
,
  table: "phones"
)
Store = DB.define("Store",

  name:
    type: String
    length: 255    

  address:
    type: String
    length: 255

  ip:
    type: String
    length: 255    

  city_id:
    type: Number   

  storeid:
    type: String   
    length: 255    

  created_at:
    type: Date
    default: Date.now

  updated_at:
    type: Date
    default: Date.now
,
  table: "stores"
)

City = DB.define("City",

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
  table: "cities"
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
User.hasMany(Cart, {as: 'carts',foreignKey: 'user_id' })
Client.hasMany(Cart, {as: 'carts',foreignKey: 'client_id' })
Client.hasMany(Phone, {as: 'phones',foreignKey: 'client_id' })
Phone.belongsTo(Client, {as: 'client', foreignKey: 'client_id'})
Cart.hasMany(CartProduct, {as: 'cart_products', foreignKey: 'cart_id'})
Cart.belongsTo(Client, {as: 'client', foreignKey: 'client_id'})
Cart.belongsTo(User, {as: 'user', foreignKey: 'user_id'})
Category.hasMany(Product, {as: 'products', foreignKey: 'category_id'})
Product.hasMany(CartProduct, {as: 'cart_products', foreignKey: 'product_id'})
CartProduct.belongsTo(Product, {as: 'product', foreignKey: 'product_id'})
CartProduct.belongsTo(Cart, {as: 'cart', foreignKey: 'cart_id'})


exports.CartProduct = CartProduct
exports.Cart = Cart
exports.Product = Product
exports.Category = Category