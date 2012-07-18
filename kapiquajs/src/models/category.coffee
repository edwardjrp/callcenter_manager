Category = require('./schema').Category
Category.validatesUniquenessOf('name')
Category.validatesPresenceOf('name')
Category.has_many(Product, {as: 'products', foreignKey: 'category_id'})
module.exports = Category