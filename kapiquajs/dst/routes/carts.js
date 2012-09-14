var Address, Cart, CartProduct, Carts, Client, OrderReply, Phone, Product, PulseBridge, Store, async, to_json, _;

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
          if (cart_client_err) {
            if (socket != null) {
              return socket.emit('cart:price:error', {
                error: JSON.stringify(cart_client_err)
              });
            }
          } else {
            socket.emit('cart:price:client', {
              client: client
            });
            if ((client.phones_count != null) && client.phones_count > 0) {
              return client.phones(function(cart_client_phones_err, phones) {
                if (cart_client_phones_err != null) {
                  if (socket != null) {
                    return socket.emit('cart:price:error', {
                      error: JSON.stringify(cart_client_phones_err)
                    });
                  }
                } else {
                  if (socket != null) {
                    return socket.emit('cart:price:client:phones', {
                      phones: phones
                    });
                  }
                }
              });
            }
          }
        });
        cart.cart_products({}, function(c_cp_err, cart_products) {
          var get_products;
          get_products = function(cp, cb) {
            return cp.product(function(p_err, product) {
              var json_cp;
              json_cp = JSON.parse(JSON.stringify(cp));
              json_cp.product = JSON.parse(JSON.stringify(product));
              return cb(null, json_cp);
            });
          };
          return async.map(cart_products, get_products, function(it_err, results) {
            var json_cart, pulse_com_error;
            if (it_err) {
              if (socket != null) {
                return socket.emit('cart:price:error', {
                  error: JSON.stringify(it_err)
                });
              }
            } else {
              if (socket != null) {
                socket.emit('cart:price:cartproducts', {
                  results: results
                });
              }
              json_cart = JSON.parse(JSON.stringify(cart));
              json_cart.cart_products = results;
              if (socket != null) {
                socket.emit('cart:price:pulse:start', {});
              }
              pulse_com_error = function(comm_err) {
                if (socket != null) {
                  return socket.emit('cart:price:error', {
                    error: JSON.stringify(comm_err)
                  });
                }
              };
              return PulseBridge.price(json_cart, pulse_com_error, function(res_data) {
                var order_reply;
                order_reply = new OrderReply(res_data);
                return cart.updateAttributes({
                  net_amount: Number(order_reply.netamount),
                  tax_amount: Number(order_reply.taxamount),
                  payment_amount: Number(order_reply.payment_amount),
                  updated_at: new Date()
                }, function(cart_update_err, updated_cart) {
                  if (cart_update_err) {
                    console.log(cart_update_err);
                    if (socket != null) {
                      return socket.emit('cart:price:error', {
                        error: JSON.stringify(comm_err)
                      });
                    }
                  } else {
                    updated_cart.cart_products({}, function(uc_cp_err, updated_cart_cart_products) {
                      var cart_product, order_item, _i, _len, _ref, _results;
                      _ref = order_reply.order_items;
                      _results = [];
                      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                        order_item = _ref[_i];
                        _results.push((function() {
                          var _j, _len1, _results1;
                          _results1 = [];
                          for (_j = 0, _len1 = updated_cart_cart_products.length; _j < _len1; _j++) {
                            cart_product = updated_cart_cart_products[_j];
                            if (Number(cart_product.quantity) === Number(order_item.quantity) && _.find(results, function(cp) {
                              return cp.id === cart_product.id;
                            }).product.productcode === order_item.code && order_item.options.join(',') === cart_product.options) {
                              _results1.push(cart_product.updateAttributes({
                                priced_at: Number(order_item.priced_at),
                                updated_at: new Date()
                              }, function(cp_update_price_error, update_price_cart_product) {
                                if (cp_update_price_error) {
                                  if (socket != null) {
                                    return socket.emit('cart:price:error', {
                                      error: JSON.stringify(cp_update_price_error)
                                    });
                                  }
                                } else {
                                  if (socket != null) {
                                    return socket.emit('cart:price:pulse:itempriced', {
                                      item_id: update_price_cart_product.id,
                                      price: update_price_cart_product.priced_at
                                    });
                                  }
                                }
                              }));
                            } else {
                              _results1.push(void 0);
                            }
                          }
                          return _results1;
                        })());
                      }
                      return _results;
                    });
                    if (socket != null) {
                      return socket.emit('cart:price:pulse:cartpriced', {
                        net_amount: updated_cart.net_amount,
                        tax_amount: updated_cart.tax_amount,
                        payment_amount: updated_cart.payment_amount
                      });
                    }
                  }
                });
              });
            }
          });
        });
        return console.log('Princing');
      }
    });
  };

  Carts.place = function(data, respond, socket) {
    return Cart.find(data.cart_id, function(cart_find_err, cart) {
      if (cart_find_err != null) {
        if (socket != null) {
          socket.emit('cart:place:error', {
            error: JSON.stringify(cart_find_err)
          });
        }
      } else {
        async.waterfall([
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
                    jcp = to_json(cp);
                    jcp.product = to_json(product);
                    return cb(null, jcp);
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
                  return callback(null, client, cart_products, phones);
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
                  return callback(null, client, cart_products, phones, addresses);
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
                return callback(null, client, cart_products, phones, addresses, store);
              }
            });
          }
        ], function(final_error, client, cart_products, phones, addresses, store) {
          if (final_error != null) {
            return console.log('Error at the end');
          } else {
            console.log(cart);
            console.log(cart_products);
            console.log(client);
            console.log(phones);
            console.log(addresses);
            return console.log(store);
          }
        });
      }
      return console.log('Placing');
    });
  };

  return Carts;

}).call(this);

to_json = function(obj) {
  return JSON.parse(JSON.stringify(obj));
};

module.exports = Carts;
