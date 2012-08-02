var Address, Cart, CartProduct, Carts, Client, OrderReply, Phone, Product, PulseBridge, Store, async, _;

Cart = require('../models/cart');

Product = require('../models/product');

Client = require('../models/client');

Store = require('../models/store');

Phone = require('../models/phone');

Address = require('../models/address');

CartProduct = require('../models/cart_product');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

async = require('async');

_ = require('underscore');

Carts = (function() {

  function Carts() {}

  Carts.price = function(data, respond, socket) {
    return Cart.find(data.cart_id, function(cart_find_err, cart) {
      if (cart_find_err != null) {
        if (socket != null) {
          return socket.emit('cart:price:error', {
            error: JSON.stringify(cart_find_err)
          });
        }
      } else {
        cart.client(function(cart_client_err, client) {
          socket.emit('cart:price:client', {
            client: client
          });
          if ((client.phones_count != null) && client.phones_count > 0) {
            client.phones(function(cart_client_phones_err, phones) {
              if (cart_client_phones_err != null) {
                if (socket != null) {
                  return socket.emit('cart:price:error', {
                    error: JSON.stringify(cart_client_phones_err)
                  });
                }
              } else {
                return socket.emit('cart:price:client:phones', {
                  phones: phones
                });
              }
            });
          }
          if ((client.addresses_count != null) && client.addresses_count > 0) {
            return client.addresses(function(cart_client_addresses_err, addresses) {
              if (cart_client_addresses_err != null) {
                if (socket != null) {
                  return socket.emit('cart:price:error', {
                    error: JSON.stringify(cart_client_addresses_err)
                  });
                }
              } else {
                return socket.emit('cart:price:client:addresses', {
                  addresses: addresses
                });
              }
            });
          }
        });
        return console.log('Princing');
      }
    });
  };

  Carts.place = function(data, respond, socket) {
    return console.log('Placing');
  };

  return Carts;

}).call(this);

module.exports = Carts;
