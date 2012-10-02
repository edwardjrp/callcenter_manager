var Product;

Product = require('./schema').Product;

Product.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = Product;
