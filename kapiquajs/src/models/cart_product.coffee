CartProduct = require('./schema').CartProduct
CartProduct.validatesPresenceOf('cart_id')
CartProduct.validatesPresenceOf('product_id')
CartProduct.validatesPresenceOf('quantity')
CartProduct.validatesNumericalityOf('quantity')
CartProduct.belongsTo(Product, {as: 'product', foreignKey: 'product_id'})
CartProduct.belongsTo(Cart, {as: 'cart', foreignKey: 'cart_id'})
module.exports = CartProduct