var Store, Stores;

Store = require('../models/store');

Stores = (function() {

  function Stores() {}

  Stores.schedule = function(data, respond) {
    if (data != null) {
      return Store.find(data.store_id, function(err, store) {
        if (err) {
          console.log(err.stack);
          return respond(err);
        } else {
          return store.schedule(respond);
        }
      });
    }
  };

  return Stores;

}).call(this);

module.exports = Stores;
