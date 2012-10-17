var Phone;

Phone = require('./schema').Phone;

Phone.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = Phone;
