Cart = require('./schema').Cart
Cart.validatesPresenceOf('user_id')
Category.has_many(CartProduct, {as: 'cart_products', foreignKey: 'cart_id'})

module.exports = Cart