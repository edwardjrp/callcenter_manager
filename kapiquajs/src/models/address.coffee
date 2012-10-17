Address = require('./schema').Address

Address.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))


module.exports = Address