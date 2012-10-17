Store = require('./schema').Store

Store.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))


module.exports = Store