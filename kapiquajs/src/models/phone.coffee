Phone = require('./schema').Phone

Phone.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))


module.exports = Phone