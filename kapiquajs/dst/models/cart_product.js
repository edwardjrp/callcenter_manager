var CartProduct, Product, async, _;

CartProduct = require('./schema').CartProduct;

Product = require('../models/product');

async = require('async');

_ = require('underscore');

CartProduct.validatesPresenceOf('cart_id');

CartProduct.validatesPresenceOf('product_id');

CartProduct.validatesPresenceOf('quantity');

CartProduct.validatesNumericalityOf('quantity');

CartProduct.addItem = function(data, respond, socket) {
  var cart_product;
  if (data != null) {
    cart_product = new CartProduct({
      cart_id: data.cart_id,
      product_id: data.product_id,
      options: data.options,
      bind_id: data.bind_id,
      quantity: Number(data.quantity),
      created_at: new Date()
    });
    return cart_product.save(function(err, result_cart_product) {
      if (err) {
        return respond(err);
      } else {
        respond(err, result_cart_product);
        return result_cart_product.cart(function(c_err, cart) {
          if (c_err) {
            return socket.emit('cart:pricing:error', 'No se pudo leer la orden actual');
          } else {
            return cart.price(socket);
          }
        });
      }
    });
  }
};

CartProduct.addCollection = function(data, respond, socket) {
  var addProduct, cart;
  if (data != null) {
    cart = null;
    addProduct = function(coupon_product, callback) {
      return Product.all({
        where: {
          productcode: coupon_product.product_code
        }
      }, function(product_error, products) {
        var cart_product, product;
        if (_.any(products)) {
          product = _.first(products);
          cart_product = new CartProduct({
            cart_id: data.cart_id,
            product_id: product.id,
            options: product.options,
            bind_id: null,
            quantity: Number(coupon_product.minimun_require) || 1,
            created_at: new Date()
          });
          return cart_product.save(function(cart_product_save_error, saved_cart_product) {
            if (cart_product_save_error != null) {
              console.error(cart_product_save_error.stack);
              return callback(cart_product_save_error);
            } else {
              return saved_cart_product.cart(function(saved_cart_product_error, current_cart) {
                var saved_cart_product_to_send;
                cart = current_cart;
                saved_cart_product_to_send = saved_cart_product.toJSON();
                saved_cart_product_to_send.product = product.toJSON();
                saved_cart_product_to_send.cart = current_cart.toJSON();
                socket.emit('cart_products:add:backwards', saved_cart_product_to_send);
                return callback();
              });
            }
          });
        } else {
          socket.emit('cart:pricing:error', "El cupón hace referencia al producto " + coupon_product.product_code + " pero este no se encontró en el listado");
          return callback();
        }
      });
    };
    return async.forEach(data.coupon_products, addProduct, function(err) {
      if (err) {
        return console.error(err.stack);
      } else {
        if (cart != null) {
          return process.nextTick(function() {
            return cart.price(socket);
          });
        }
      }
    });
  }
};

CartProduct.updateItem = function(data, respond, socket, trigger_pricing) {
  if (data != null) {
    return CartProduct.find(data.id, function(cp_err, cart_product) {
      var attributes;
      if (cp_err != null) {
        return respond(cp_err);
      } else {
        if (cart_product != null) {
          attributes = {};
          if (data.product_id) {
            attributes['product_id'] = data.product_id;
          }
          attributes['bind_id'] = data.bind_id || null;
          if ((data != null) && (data.quantity != null)) {
            attributes['quantity'] = Number(data.quantity);
          }
          if ((data != null) && (data.options != null)) {
            attributes['options'] = data.options;
          }
          attributes['updated_at'] = new Date();
          console.log(attributes);
          return cart_product.updateAttributes(attributes, function(cp_update_err, updated_cart_product) {
            if (cp_update_err != null) {
              console.error(cp_update_err.stack);
              return respond(cp_update_err);
            } else {
              socket.emit('cart_products:updated', updated_cart_product.toJSON());
              respond(cp_update_err, updated_cart_product);
              if ((trigger_pricing != null) && trigger_pricing === true) {
                return updated_cart_product.cart(function(err, cart_to_price) {
                  if (err) {
                    console.error(err.stack);
                    return socket.emit('cart:pricing:error', 'No se pudo leer la orden actual');
                  } else {
                    return cart_to_price.price(socket);
                  }
                });
              }
            }
          });
        }
      }
    });
  }
};

CartProduct.removeItem = function(data, respond, socket) {
  if (data != null) {
    return CartProduct.find(data.id, function(cp_err, cart_product) {
      if (cp_err) {
        return respond(cp_err);
      } else {
        if (cart_product != null) {
          return cart_product.cart(function(err, cart) {
            return cart_product.destroy(function(del_err) {
              if (del_err != null) {
                return respond(del_err);
              } else {
                respond(del_err, data.id);
                return cart.cart_products({}, function(cp_list_err, cart_products) {
                  if (cp_list_err) {
                    return console.erro(cp_list_err.stack);
                  } else {
                    if (_.isEmpty(cart_products)) {
                      return socket.emit('cart:empty', {
                        cart: cart
                      });
                    } else {
                      return cart.price(socket);
                    }
                  }
                });
              }
            });
          });
        }
      }
    });
  }
};

module.exports = CartProduct;
