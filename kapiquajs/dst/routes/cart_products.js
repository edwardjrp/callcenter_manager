var Cart, CartProduct, CartProducts, OrderReply, Product, PulseBridge, async, parsed_options, to_json, _;

Cart = require('../models/cart');

Product = require('../models/product');

CartProduct = require('../models/cart_product');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

async = require('async');

_ = require('underscore');

CartProducts = (function() {

  function CartProducts() {}

  CartProducts.create = function(data, respond, socket) {
    return CartProduct.add(data, respond, socket);
  };

  CartProducts.update = function(data, respond, socket) {
    return CartProduct.find(data.id, function(cp_err, cart_product) {
      if (cp_err != null) {
        return respond({
          type: "error",
          data: 'El articulo no esta presente'
        });
      } else {
        return cart_product.updateAttributes({
          options: data.options,
          quantity: Number(data.quantity),
          updated_at: new Date()
        }, function(err) {
          if ((err != null)) {
            console.log(cart_product.errors);
            console.log(err);
            return respond({
              type: "error",
              data: cart_product.errors || err
            });
          } else {
            return CartProducts.current_cart(cart_product.cart_id, respond, socket);
          }
        });
      }
    });
  };

  CartProducts.destroy = function(data, respond, socket) {
    var current_cart_id;
    current_cart_id = data.cart;
    if (current_cart_id != null) {
      return CartProduct.find(data.id, function(cp_err, cart_product) {
        if (cp_err) {
          return respond({
            type: "error",
            data: 'El articulo no esta presente'
          });
        } else {
          return cart_product.destroy(function(del_err) {
            if (del_err != null) {
              console.log(cart_product.errors);
              console.log(del_err);
              return respond({
                type: "error",
                data: cart_product.errors || del_err
              });
            } else {
              return CartProducts.current_cart(current_cart_id, respond, socket);
            }
          });
        }
      });
    }
  };

  CartProducts.save_item = function(cart_product, respond, socket) {
    return cart_product.save(function(err) {
      if ((err != null)) {
        console.log(cart_product.errors);
        console.log(err);
        return respond({
          type: "error",
          data: cart_product.errors || err
        });
      } else {
        return CartProducts.current_cart(cart_product.cart_id, respond, socket);
      }
    });
  };

  CartProducts.current_cart = function(cart_id, respond, socket) {
    return Cart.find(cart_id, function(c_err, cart) {
      return cart.cart_products({}, function(c_cp_err, cart_products) {
        var get_products;
        get_products = function(cp, cb) {
          return cp.product(function(p_err, product) {
            var json_cp;
            json_cp = JSON.parse(JSON.stringify(cp));
            json_cp.product = JSON.parse(JSON.stringify(product));
            return parsed_options(json_cp, cb);
          });
        };
        return async.map(cart_products, get_products, function(it_err, results) {
          var json_cart, pulse_com_error;
          if (it_err) {
            return respond({
              type: "error",
              data: it_err
            });
          } else {
            json_cart = JSON.parse(JSON.stringify(cart));
            json_cart.cart_products = results;
            respond({
              type: "success",
              data: json_cart
            });
            if (socket != null) {
              socket.emit('start_price_sync', {
                user: 'pulse ',
                msg: new Date(json_cart.updated_at)
              });
            }
            pulse_com_error = function(comm_err) {
              console.log(comm_err);
              if (socket != null) {
                return socket.emit('data_error', {
                  type: 'pulse_connection',
                  msg: JSON.stringify(comm_err)
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
                    return socket.emit('data_error', {
                      type: 'db_error',
                      msg: JSON.stringify(cart_update_err)
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
                                  return socket.emit('data_error', {
                                    type: 'pulse_connection',
                                    msg: JSON.stringify(cp_update_price_error)
                                  });
                                }
                              } else {
                                if (socket != null) {
                                  return socket.emit('item_price_sync', {
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
                    return socket.emit('cart_price_sync', {
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
    });
  };

  return CartProducts;

}).call(this);

parsed_options = function(cart_product, callback) {
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
            product: to_json(current_product),
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

to_json = function(obj) {
  return JSON.parse(JSON.stringify(obj));
};

module.exports = CartProducts;
