var User;

User = require('./schema').User;

User.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = User;
