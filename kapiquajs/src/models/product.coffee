Product = require('./schema').Product


Product.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))

module.exports = Product