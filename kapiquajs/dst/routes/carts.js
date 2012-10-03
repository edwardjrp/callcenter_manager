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
    return console.log('need to reimplement');
  };

  Carts.place = function(data, respond, socket) {
    return Cart.find(data.cart_id, function(cart_find_err, cart) {
      if (cart_find_err != null) {
        if (socket != null) {
          return socket.emit('cart:place:error', {
            error: JSON.stringify(cart_find_err)
          });
        }
      } else {
        return async.waterfall([
          function(callback) {
            return cart.client(function(cart_client_err, client) {
              if (cart_client_err) {
                if (socket != null) {
                  return socket.emit('cart:place:error', {
                    error: JSON.stringify(cart_client_err)
                  });
                }
              } else {
                return callback(null, client);
              }
            });
          }, function(client, callback) {
            return cart.cart_products({}, function(c_cp_err, cart_products) {
              var get_products;
              if (c_cp_err) {
                if (socket != null) {
                  return socket.emit('cart:place:error', {
                    error: JSON.stringify(c_cp_err)
                  });
                }
              } else {
                get_products = function(cp, cb) {
                  return cp.product(function(p_err, product) {
                    var jcp;
                    jcp = Carts.to_json(cp);
                    jcp.product = Carts.to_json(product);
                    return Carts.parsed_options(jcp, cb);
                  });
                };
                return async.map(cart_products, get_products, function(it_err, cart_products) {
                  if (it_err) {
                    if (socket != null) {
                      return socket.emit('cart:place:error', {
                        error: JSON.stringify(it_err)
                      });
                    }
                  } else {
                    return callback(null, client, cart_products);
                  }
                });
              }
            });
          }, function(client, cart_products, callback) {
            if ((client.phones_count != null) && client.phones_count > 0) {
              return client.phones(function(cart_client_phones_err, phones) {
                if (cart_client_phones_err != null) {
                  if (socket != null) {
                    return socket.emit('cart:place:error', {
                      error: JSON.stringify(cart_client_phones_err)
                    });
                  }
                } else {
                  return callback(null, client, cart_products, Carts.to_json(phones));
                }
              });
            } else {
              return callback(null, client, cart_products, []);
            }
          }, function(client, cart_products, phones, callback) {
            if ((client.addresses_count != null) && client.addresses_count > 0) {
              return client.addresses(function(cart_client_addresses_err, addresses) {
                if (cart_client_addresses_err != null) {
                  if (socket != null) {
                    return socket.emit('cart:place:error', {
                      error: JSON.stringify(cart_client_addresses_err)
                    });
                  }
                } else {
                  return callback(null, client, cart_products, phones, Carts.to_json(addresses));
                }
              });
            } else {
              return callback(null, client, cart_products, phones, []);
            }
          }, function(client, cart_products, phones, addresses, callback) {
            return cart.store(function(cart_store_err, store) {
              if (cart_store_err) {
                if (socket != null) {
                  return socket.emit('cart:place:error', {
                    error: JSON.stringify(cart_store_err)
                  });
                }
              } else {
                return callback(null, client, cart_products, phones, addresses, Carts.to_json(store));
              }
            });
          }
        ], function(final_error, client, cart_products, phones, addresses, store) {
          var assempled_cart, pulse_com_error;
          if (final_error != null) {
            return console.log('Error at the end');
          } else {
            pulse_com_error = function(comm_err) {
              return console.log(comm_err);
            };
            if (cart.completed !== true) {
              assempled_cart = Carts.to_json(cart);
              assempled_cart.client = client;
              assempled_cart.cart_products = cart_products;
              assempled_cart.phones = phones;
              assempled_cart.addresses = addresses;
              assempled_cart.store = store;
              if (assempled_cart.store && assempled_cart.client && assempled_cart.cart_products.length > 0 && assempled_cart.phones.length > 0) {
                return PulseBridge.price(assempled_cart, pulse_com_error, function(res_data) {
                  var order_reply;
                  order_reply = new OrderReply(res_data);
                  if (order_reply.status === '0') {
                    return cart.updateAttributes({
                      store_order_id: order_reply.reply_id,
                      completed: true
                    }, function(cart_update_err, updated_cart) {
                      return console.log(updated_cart);
                    });
                  } else {
                    return console.log("Notify of the pulse response here : " + order_reply.status_text);
                  }
                });
              } else {
                return console.log('Princing conditions not met');
              }
            } else {
              return console.log('Cart is complete');
            }
          }
        });
      }
    });
  };

  Carts.to_json = function(obj) {
    return JSON.parse(JSON.stringify(obj));
  };

  Carts.parsed_options = function(cart_product, callback) {
    var current_category_id, product_options, recipe;
    if (cart_product.product.options === '' && cart_product.options === '') {
      return [];
    }
    product_options = [];
    recipe = cart_product.options || cart_product.product.options;
    current_category_id = cart_product.product.category_id;
    return Product.all({
      where: {
        category_id: current_category_id,
        options: 'OPTION'
      }
    }, function(cat_options_products_err, cat_options_products) {
      if (_.any(recipe.split(','))) {
        _.each(_.compact(recipe.split(',')), function(code) {
          var code_match, current_part, current_product, current_quantity, product_option;
          code_match = code.match(/^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([W12]))?/);
          if (code_match != null) {
            if (!(code_match[1] != null) || code_match[1] === '') {
              code_match[1] = '1';
            }
            current_quantity = code_match[1];
            current_product = _.find(cat_options_products, function(op) {
              return op.productcode === code_match[2];
            });
            current_part = code_match[3] || 'W';
            product_option = {
              quantity: Number(current_quantity),
              product: Carts.to_json(current_product),
              part: current_part
            };
            return product_options.push(product_option);
          }
        });
        cart_product.product_options = product_options;
        return callback(null, cart_product);
      }
    });
  };

  return Carts;

}).call(this);

module.exports = Carts;
