var Client, _;

Client = require('./schema').Client;

_ = require('underscore');

Client.prototype.last_phone = function(cb) {
  var me;
  me = this;
  return me.phones({
    order: 'id'
  }, function(err, phones) {
    var target, target_phone;
    if (err) {
      console.error(err.stack);
      return cb(err);
    } else {
      target = _.find(phones, function(phone) {
        return phone.id === me.target_phone_id;
      });
      target_phone = target || _.first(phones);
      return cb(err, target_phone);
    }
  });
};

Client.prototype.last_address = function(cb) {
  var me;
  me = this;
  return me.addresses({
    order: 'id'
  }, function(err, addresses) {
    var target, target_address;
    if (err) {
      console.error(err.stack);
      return cb(err);
    } else {
      if (_.any(addresses)) {
        target = _.find(addresses, function(address) {
          return address.id === me.target_address_id;
        });
        target_address = target || _.first(address);
        return cb(err, target_address);
      } else {
        return cb(err, null);
      }
    }
  });
};

module.exports = Client;
