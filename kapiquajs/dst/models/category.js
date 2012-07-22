var Category;

Category = require('./schema').Category;

Category.validatesUniquenessOf('name');

Category.validatesPresenceOf('name');

module.exports = Category;
