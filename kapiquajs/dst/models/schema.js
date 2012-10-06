var Address, Area, Cart, CartCoupon, CartProduct, Category, City, Client, Config, Coupon, DB, Phone, Product, Schema, Setting, Store, Street, User, jugglingdb;

Config = require('../config');

jugglingdb = require('jugglingdb');

Schema = jugglingdb.Schema;

DB = new Schema('postgres', {
  'url': Config.connection_string
});

Cart = DB.define("Cart", {
  id: {
    type: Number
  },
  user_id: {
    type: Number
  },
  client_id: {
    type: Number
  },
  communication_failed: {
    type: Boolean
  },
  service_method: {
    type: String,
    length: 255
  },
  status_text: {
    type: String,
    length: 255
  },
  store_id: {
    type: Number
  },
  store_order_id: {
    type: String,
    length: 255
  },
  business_date: {
    type: Date
  },
  advance_order_time: {
    type: Date
  },
  net_amount: {
    type: Number
  },
  tax_amount: {
    type: Number
  },
  tax1_amount: {
    type: Number
  },
  tax2_amount: {
    type: Number
  },
  payment_amount: {
    type: Number
  },
  message: {
    type: String,
    length: 255
  },
  order_text: {
    type: String,
    length: 255
  },
  order_progress: {
    type: String,
    length: 255
  },
  can_place_order: {
    type: Boolean
  },
  delivery_instructions: {
    type: Schema.Text
  },
  payment_type: {
    type: String,
    length: 255
  },
  credit_cart_approval_name: {
    type: String,
    length: 255
  },
  fiscal_number: {
    type: String,
    length: 255
  },
  fiscal_type: {
    type: String,
    length: 255
  },
  company_name: {
    type: String,
    length: 255
  },
  discount: {
    type: Number
  },
  discount_auth_id: {
    type: Number
  },
  completed: {
    type: Boolean,
    "default": false
  },
  message_mask: {
    type: Number
  },
  reason_id: {
    type: Number
  },
  complete_on: {
    type: Date
  },
  placed_at: {
    type: Date
  },
  exonerated: {
    type: Boolean,
    "default": false
  },
  started_on: {
    type: Date
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "carts"
});

Coupon = DB.define("Coupon", {
  code: {
    type: String,
    length: 255
  },
  description: {
    type: Schema.Text
  },
  custom_description: {
    type: Schema.Text
  },
  generated_description: {
    type: Schema.Text
  },
  minimum_price: {
    type: Number
  },
  hidden: {
    type: Boolean,
    "default": false
  },
  secure: {
    type: Boolean,
    "default": false
  },
  effective_days: {
    type: String,
    length: 255
  },
  order_sources: {
    type: String,
    length: 255
  },
  service_methods: {
    type: String,
    length: 255
  },
  expiration_date: {
    type: Date
  },
  effective_date: {
    type: Date
  },
  enable: {
    type: Boolean,
    "default": true
  },
  discontinued: {
    type: Boolean,
    "default": false
  },
  target_products: {
    type: Schema.Text
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "coupons"
});

CartCoupon = DB.define("CartCoupon", {
  cart_id: {
    type: Number
  },
  coupon_id: {
    type: Number
  },
  code: {
    type: String,
    length: 255
  },
  target_products: {
    type: Schema.Text
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "cart_coupons"
});

Category = DB.define("Category", {
  name: {
    type: String,
    length: 255
  },
  has_options: {
    type: Boolean,
    "default": false
  },
  type_unit: {
    type: Boolean,
    "default": false
  },
  multi: {
    type: Boolean,
    "default": false
  },
  hidden: {
    type: Boolean,
    "default": false
  },
  base_product: {
    type: Number
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "categories"
});

Product = DB.define("Product", {
  category_id: {
    type: Number
  },
  productcode: {
    type: String,
    length: 255
  },
  productname: {
    type: String,
    length: 255
  },
  options: {
    type: String,
    length: 255
  },
  sizecode: {
    type: String,
    length: 255
  },
  flavorcode: {
    type: String,
    length: 255
  },
  optionselectiongrouptype: {
    type: String,
    length: 255
  },
  productoptionselectiongroup: {
    type: String,
    length: 255
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "products"
});

Client = DB.define("Client", {
  first_name: {
    type: String,
    length: 255
  },
  last_name: {
    type: String,
    length: 255
  },
  email: {
    type: String,
    length: 255
  },
  idnumber: {
    type: String,
    length: 255
  },
  target_address_id: {
    type: Number
  },
  target_phone_id: {
    type: Number
  },
  phones_count: {
    type: Number
  },
  addresses_count: {
    type: Number
  },
  active: {
    type: Boolean,
    "default": true
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "clients"
});

User = DB.define("User", {
  username: {
    type: String,
    length: 255
  },
  first_name: {
    type: String,
    length: 255
  },
  last_name: {
    type: String,
    length: 255
  },
  auth_token: {
    type: String,
    length: 255
  },
  password_digest: {
    type: String,
    length: 255
  },
  role_mask: {
    type: Number
  },
  last_action_at: {
    type: Date,
    "default": Date.now
  },
  login_count: {
    type: Number
  },
  carts_count: {
    type: Number
  },
  idnumber: {
    type: String,
    length: 255
  },
  active: {
    type: Boolean,
    "default": true
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "users"
});

Setting = DB.define("Setting", {
  "var": {
    type: String,
    length: 255
  },
  value: {
    type: Schema.Text
  },
  thing_id: {
    type: Number
  },
  thing_type: {
    type: String,
    length: 30
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "settings"
});

Phone = DB.define("Phone", {
  number: {
    type: String,
    length: 255
  },
  ext: {
    type: String,
    length: 255
  },
  client_id: {
    type: Number
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "phones"
});

Store = DB.define("Store", {
  name: {
    type: String,
    length: 255
  },
  address: {
    type: String,
    length: 255
  },
  ip: {
    type: String,
    length: 255
  },
  city_id: {
    type: Number
  },
  storeid: {
    type: String,
    length: 255
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "stores"
});

City = DB.define("City", {
  name: {
    type: String,
    length: 255
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "cities"
});

Area = DB.define("Area", {
  name: {
    type: String,
    length: 255
  },
  city_id: {
    type: Number
  },
  store_id: {
    type: Number
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "areas"
});

Street = DB.define("Street", {
  name: {
    type: String,
    length: 255
  },
  area_id: {
    type: Number
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "streets"
});

Address = DB.define("Address", {
  client_id: {
    type: Number
  },
  street_id: {
    type: Number
  },
  number: {
    type: Number
  },
  unit_type: {
    type: Number
  },
  postal_code: {
    type: String,
    length: 255
  },
  delivery_instructions: {
    type: Schema.Text
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "addresses"
});

CartProduct = DB.define("CartProduct", {
  cart_id: {
    type: Number
  },
  product_id: {
    type: Number
  },
  quantity: {
    type: Number
  },
  options: {
    type: String,
    length: 255
  },
  bind_id: {
    type: Number
  },
  priced_at: {
    type: Number
  },
  created_at: {
    type: Date,
    "default": Date.now
  },
  updated_at: {
    type: Date,
    "default": Date.now
  }
}, {
  table: "cart_products"
});

User.hasMany(Cart, {
  as: 'carts',
  foreignKey: 'user_id'
});

City.hasMany(Store, {
  as: 'stores',
  foreignKey: 'city_id'
});

City.hasMany(Area, {
  as: 'areas',
  foreignKey: 'city_id'
});

Area.belongsTo(City, {
  as: 'city',
  foreignKey: 'city_id'
});

Area.belongsTo(Store, {
  as: 'store',
  foreignKey: 'store_id'
});

Area.hasMany(Street, {
  as: 'street',
  foreignKey: 'area_id'
});

Street.belongsTo(Area, {
  as: 'area',
  foreignKey: 'area_id'
});

Street.hasMany(Address, {
  as: 'addresses',
  foreignKey: 'street_id'
});

Address.belongsTo(Client, {
  as: 'client',
  foreignKey: 'client_id'
});

Address.belongsTo(Street, {
  as: 'street',
  foreignKey: 'street_id'
});

Store.belongsTo(City, {
  as: 'city',
  foreignKey: 'city_id'
});

Store.hasMany(Cart, {
  as: 'carts',
  foreignKey: 'store_id'
});

Client.hasMany(Cart, {
  as: 'carts',
  foreignKey: 'client_id'
});

Client.hasMany(Phone, {
  as: 'phones',
  foreignKey: 'client_id'
});

Client.hasMany(Address, {
  as: 'addresses',
  foreignKey: 'client_id'
});

Phone.belongsTo(Client, {
  as: 'client',
  foreignKey: 'client_id'
});

Cart.hasMany(CartProduct, {
  as: 'cart_products',
  foreignKey: 'cart_id'
});

Cart.hasMany(CartCoupon, {
  as: 'cart_coupons',
  foreignKey: 'cart_id'
});

Cart.belongsTo(Client, {
  as: 'client',
  foreignKey: 'client_id'
});

Cart.belongsTo(User, {
  as: 'user',
  foreignKey: 'user_id'
});

Cart.belongsTo(Store, {
  as: 'store',
  foreignKey: 'store_id'
});

Category.hasMany(Product, {
  as: 'products',
  foreignKey: 'category_id'
});

Product.hasMany(CartProduct, {
  as: 'cart_products',
  foreignKey: 'product_id'
});

Product.belongsTo(Category, {
  as: 'category',
  foreignKey: 'category_id'
});

Coupon.hasMany(CartCoupon, {
  as: 'cart_coupons',
  foreignKey: 'coupon_id'
});

CartCoupon.belongsTo(Coupon, {
  as: 'coupon',
  foreignKey: 'coupon_id'
});

CartCoupon.belongsTo(Cart, {
  as: 'cart',
  foreignKey: 'cart_id'
});

CartProduct.belongsTo(Product, {
  as: 'product',
  foreignKey: 'product_id'
});

CartProduct.belongsTo(Cart, {
  as: 'cart',
  foreignKey: 'cart_id'
});

exports.Setting = Setting;

exports.Cart = Cart;

exports.User = User;

exports.City = City;

exports.Area = Area;

exports.Street = Street;

exports.Address = Address;

exports.Store = Store;

exports.Client = Client;

exports.Phone = Phone;

exports.Product = Product;

exports.Category = Category;

exports.Coupon = Coupon;

exports.CartCoupon = CartCoupon;

exports.CartProduct = CartProduct;
