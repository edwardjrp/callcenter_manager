var Cart, async, _;

Cart = require('./schema').Cart;

async = require('async');

_ = require('underscore');

Cart.validatesPresenceOf('user_id');

Cart.read = function(data, respond, socket) {
  var id;
  id = data.id;
  return Cart.find(data.cart_id, function(cart_find_err, cart) {
    if (cart_find_err != null) {
      return respond(cart_find_err);
    } else {
      console.log('HELLO');
      return Cart.products(data.id, function(err, collection) {
        if (err) {
          console.log(err);
        }
        if (collection) {
          return console.log(collection);
        }
      });
    }
  });
};

Cart.products = function(id, respond) {
  return Cart.command("SELECT \"products\".* FROM \"products\" INNER JOIN \"cart_products\" ON \"products\".\"id\" = \"cart_products\".\"product_id\" WHERE \"cart_products\".\"cart_id\" = " + id, function(err, collection) {
    if (err) {
      return respond(err);
    } else {
      return respond(err, collection);
    }
  });
};

module.exports = Cart;
