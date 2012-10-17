User = require('./schema').User


User.prototype.simplified = ->
  JSON.parse(JSON.stringify(this))


module.exports = User