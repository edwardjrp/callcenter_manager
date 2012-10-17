var Address;

Address = require('./schema').Address;

Address.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = Address;
