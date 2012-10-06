var CartProduct, async, _;

CartProduct = require('./schema').CartProduct;

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
        result_cart_product.cart(function(c_err, cart) {
          if (c_err) {
            return socket.emit('cart:pricing:error', 'No se pudo leer la orden actual');
          } else {
            return cart.price(socket);
          }
        });
        return respond(err, result_cart_product);
      }
    });
  }
};

CartProduct.updateItem = function(data, respond, socket, trigger_pricing) {
  if (data != null) {
    return CartProduct.find(data.id, function(cp_err, cart_product) {
      if (cp_err != null) {
        return respond(err);
      } else {
        if (cart_product != null) {
          return cart_product.updateAttributes({
            quantity: Number(data.quantity),
            options: data.options,
            updated_at: new Date()
          }, function(err, updated_cart_product) {
            if (err != null) {
              return respond(err);
            } else {
              socket.emit('cart_products:updated', updated_cart_product.toJSON());
              respond(err, updated_cart_product);
              if ((trigger_pricing != null) && trigger_pricing === true) {
                return updated_cart_product.cart(function(err, cart_to_price) {
                  if (err) {
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
        return cart_product.cart(function(err, cart) {
          return cart_product.destroy(function(del_err) {
            if (del_err != null) {
              return respond(del_err);
            } else {
              respond(del_err, data.id);
              return cart.price(socket);
            }
          });
        });
      }
    });
  }
};

CartProduct.prototype.simplified = function() {
  return JSON.parse(JSON.stringify(this));
};

module.exports = CartProduct;
