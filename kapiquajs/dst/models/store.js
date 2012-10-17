var Store;

Store = require('./schema').Store;

Store.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = Store;
