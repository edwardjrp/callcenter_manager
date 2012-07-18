Product = require('./schema').Product
Product.has_many(CartProduct, {as: 'cart_products', foreignKey: 'product_id'})


module.exports = Product