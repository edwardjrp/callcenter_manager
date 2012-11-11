var Address, Cart, CartProduct, Client, OrderReply, Phone, Product, PulseBridge, Setting, Store, User, async, libxmljs, _;

Cart = require('./schema').Cart;

async = require('async');

_ = require('underscore');

PulseBridge = require('../pulse_bridge/pulse_bridge');

OrderReply = require('../pulse_bridge/order_reply');

CartProduct = require('../models/cart_product');

Client = require('../models/client');

Store = require('../models/store');

libxmljs = require("libxmljs");

Phone = require('../models/phone');

Product = require('../models/product');

User = require('../models/user');

Address = require('../models/address');

Setting = require('../models/setting');

Cart.validatesPresenceOf('user_id');

Cart.prototype.products = function(cb) {
  return Cart.schema.adapter.query("SELECT \"products\".* FROM \"products\" INNER JOIN \"cart_products\" ON \"products\".\"id\" = \"cart_products\".\"product_id\" WHERE \"cart_products\".\"cart_id\" = " + this.id, function(err, collection) {
    if (err) {
      console.error(err.stack);
      return cb(err);
    } else {
      return cb(err, collection);
    }
  });
};

Cart.prototype.status = function(socket) {
  var me;
  me = this;
  if (me.completed === true && (me.store_order_id != null) && me.store_order_i !== '') {
    return me.store(function(cart_store_err, store) {
      if (cart_store_err) {
        console.error(cart_store_err.stack);
        return socket.emit('cart:place:error', 'No se pudo acceder a la tienda para la esta orden');
      } else {
        return Setting.kapiqua(function(err, settings) {
          var cart_request, pulse_com_error;
          if (err) {
            return console.error(err.stack);
          } else {
            pulse_com_error = function(comm_err) {
              return socket.emit('cart:status:error', 'Un error impidio solicitar el status de la orden a pulse');
            };
            cart_request = new PulseBridge(me.toJSON(), store.storeid, store.ip, settings.pulse_port);
            return cart_request.status(pulse_com_error, function(res_data) {
              var doc;
              if (res_data != null) {
                doc = libxmljs.parseXmlString(res_data);
                if (doc.get('//OrderProgress') != null) {
                  return me.updateAttributes({
                    order_progress: doc.get('//OrderProgress').text()
                  }, function(cart_update_error, updated_cart) {
                    if (cart_update_error) {
                      return console.error(cart_update_error.stack);
                    } else {
                      return socket.emit('cart:status:pulse', {
                        updated_cart: updated_cart
                      });
                    }
                  });
                }
              }
            });
          }
        });
      }
    });
  }
};

Cart.prototype.price = function(socket, io) {
  var me;
  me = this;
  return async.waterfall([
    function(callback) {
      return me.cart_products({}, function(c_cp_err, cart_products) {
        var json_and_binded;
        if (c_cp_err) {
          console.error(c_cp_err.stack);
          return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
        } else {
          json_and_binded = function(cart_product, callback) {
            if (cart_product.bind_id != null) {
              return Product.find(cart_product.bind_id, function(error, product) {
                var current_cart_product;
                if (error) {
                  return console.error(error.stack);
                } else {
                  current_cart_product = cart_product.toJSON();
                  current_cart_product.binded_product = product.toJSON();
                  return callback(error, current_cart_product);
                }
              });
            } else {
              return callback(null, cart_product.toJSON());
            }
          };
          return async.map(cart_products, json_and_binded, function(error, current_cart_products) {
            return callback(null, current_cart_products);
          });
        }
      });
    }, function(current_cart_products, callback) {
      return me.products(function(c_p_err, products) {
        if (c_p_err) {
          console.error(c_p_err.stack);
          return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
        } else {
          _.each(current_cart_products, function(current_cart_product) {
            return current_cart_product.product = _.find(products, function(product) {
              return product.id === current_cart_product.product_id;
            });
          });
          return callback(null, current_cart_products);
        }
      });
    }, function(current_cart_products, callback) {
      return me.cart_coupons(function(c_c_err, cart_coupons) {
        var current_cart_coupons;
        if (c_c_err) {
          console.error(c_c_err.stack);
          return socket.emit('cart:price:error', 'No se pudo acceder a la lista de cupones para esta orden');
        } else {
          current_cart_coupons = _.map(cart_coupons, function(cart_coupon) {
            return cart_coupon.toJSON();
          });
          return callback(null, current_cart_products, current_cart_coupons);
        }
      });
    }
  ], function(final_error, current_cart_products, current_cart_coupons) {
    var current_cart;
    if (final_error != null) {
      console.error(final_error.stack);
      return socket.emit('cart:price:error', 'Un error impidio solitar el precio de esta orden');
    } else {
      current_cart = me.toJSON();
      current_cart.cart_products = current_cart_products;
      current_cart.cart_coupons = current_cart_coupons;
      if (current_cart_products.length > 0) {
        return Setting.kapiqua(function(err, settings) {
          var cart_request, pulse_com_error;
          if (err) {
            return console.error(err.stack);
          } else {
            pulse_com_error = function(comm_err) {
              socket.emit('cart:price:error', 'Un error de comunicación impidio solitar el precio de esta orden, la aplicacion no podra funcionar correctamente en este estado');
              return io.sockets["in"]('admins').emit('system:cart:price:error', current_cart);
            };
            cart_request = new PulseBridge(current_cart, settings.price_store_id, settings.price_store_ip, settings.pulse_port);
            try {
              return cart_request.price(pulse_com_error, function(res_data) {
                var order_reply;
                order_reply = new OrderReply(res_data, current_cart_products);
                if (order_reply.status === '0') {
                  me.updatePrices(order_reply, socket);
                }
                socket.emit('cart:priced', {
                  order_reply: order_reply,
                  items: order_reply.products()
                });
                if (order_reply.status === '6') {
                  return socket.emit('cart:price:error', 'La orden tiene cupones incompletos');
                }
              });
            } catch (err_pricing) {
              socket.emit('cart:price:error', 'Un error impidio solitar el precio de esta orden');
              io.sockets["in"]('admins').emit('system:cart:price:error', current_cart);
              return console.error(err_pricing.stack);
            }
          }
        });
      } else {
        return socket.emit('cart:price:error', 'No se pudo acceder a la lista de productos para esta orden');
      }
    }
  });
};

Cart.prototype.comm_failed = function(socket, io) {
  return this.updateAttributes({
    communication_failed: true,
    message_mask: 9
  }, function(err, updated_cart) {
    if (err) {
      return console.error(err.stack);
    } else {
      socket.emit('cart:place:comm_failed', updated_cart);
      return io.sockets["in"]('admins').emit('system:cart:comm_failed', updated_cart);
    }
  });
};

Cart.prototype.updatePrices = function(order_reply, socket) {
  var prices_attributes;
  prices_attributes = {};
  prices_attributes['can_place_order'] = order_reply.can_place;
  prices_attributes['net_amount'] = order_reply.netamount;
  prices_attributes['tax_amount'] = order_reply.taxamount;
  prices_attributes['tax1_amount'] = order_reply.tax1amount;
  prices_attributes['tax2_amount'] = order_reply.tax2amount;
  prices_attributes['payment_amount'] = order_reply.payment_amount;
  prices_attributes['discount'] = 0.0;
  prices_attributes['discount_auth_id'] = null;
  prices_attributes['exonerated'] = false;
  prices_attributes['exoneration_authorizer'] = null;
  return this.updateAttributes(prices_attributes, function(err, updated_cart) {
    if (err) {
      console.error(err.stack);
      return socket.emit('cart:price:error', 'No se pudo actualizar los precios en la base de datos');
    } else {
      return _.each(order_reply.products(), function(pricing) {
        return CartProduct.find(pricing.cart_product_id, function(cp_err, cart_product) {
          if (cp_err == null) {
            if (cart_product != null) {
              return cart_product.updateAttributes({
                priced_at: pricing.priced_at
              }, function(update_err, updated_cart_product) {
                if (update_err) {
                  return console.error(update_err);
                }
              });
            }
          }
        });
      });
    }
  });
};

Cart.prototype.place = function(data, socket, io) {
  var me;
  me = this;
  return async.waterfall([
    function(callback) {
      return me.cart_products({}, function(c_cp_err, cart_products) {
        var current_cart_products;
        if (c_cp_err) {
          console.error(c_cp_err.stack);
          return socket.emit('cart:place:error', 'No se pudo acceder a la lista de productos para esta orden');
        } else {
          current_cart_products = _.map(cart_products, function(cart_product) {
            return cart_product.toJSON();
          });
          return callback(null, current_cart_products);
        }
      });
    }, function(current_cart_products, callback) {
      return me.products(function(c_p_err, products) {
        if (c_p_err) {
          console.error(c_p_err.stack);
          return socket.emit('cart:place:error', 'No se pudo acceder a la lista de productos para esta orden');
        } else {
          _.each(current_cart_products, function(current_cart_product) {
            return current_cart_product.product = _.find(products, function(product) {
              return product.id === current_cart_product.product_id;
            });
          });
          return callback(null, current_cart_products);
        }
      });
    }, function(current_cart_products, callback) {
      return me.cart_coupons(function(c_c_err, cart_coupons) {
        var current_cart_coupons;
        if (c_c_err) {
          console.error(c_c_err.stack);
          return socket.emit('cart:place:error', 'No se pudo acceder a la lista de cupones para esta orden');
        } else {
          current_cart_coupons = _.map(cart_coupons, function(cart_coupon) {
            return cart_coupon.toJSON();
          });
          return callback(null, current_cart_products, current_cart_coupons);
        }
      });
    }, function(current_cart_products, current_cart_coupons, callback) {
      return me.client(function(cart_client_err, client) {
        if (cart_client_err) {
          console.error(cart_client_err.stack);
          return socket.emit('cart:place:error', 'No se pudo cargar el cliente para esta orden');
        } else {
          return callback(null, current_cart_products, current_cart_coupons, client);
        }
      });
    }, function(current_cart_products, current_cart_coupons, client, callback) {
      return me.user(function(cart_user_err, user) {
        if (cart_user_err) {
          console.error(cart_user_err.stack);
          return socket.emit('cart:place:error', 'No se pudo cargar el agente para esta orden');
        } else {
          return callback(null, current_cart_products, current_cart_coupons, client, user);
        }
      });
    }, function(current_cart_products, current_cart_coupons, client, user, callback) {
      return client.last_phone(function(l_p_err, phone) {
        if (l_p_err) {
          return console.error(l_p_err.stack);
        } else {
          return callback(null, current_cart_products, current_cart_coupons, client, user, phone);
        }
      });
    }, function(current_cart_products, current_cart_coupons, client, user, phone, callback) {
      return client.last_address(function(l_a_err, address) {
        if (l_a_err) {
          return console.error(l_a_err.stack);
        } else {
          return callback(null, current_cart_products, current_cart_coupons, client, user, phone, address);
        }
      });
    }, function(current_cart_products, current_cart_coupons, client, user, phone, address, callback) {
      return me.store(function(cart_store_err, store) {
        if (cart_store_err) {
          console.error(cart_store_err.stack);
          return socket.emit('cart:place:error', 'No se pudo acceder a la tienda para la esta orden');
        } else {
          return callback(null, current_cart_products, current_cart_coupons, client, user, phone, address, store);
        }
      });
    }
  ], function(final_error, current_cart_products, current_cart_coupons, client, user, phone, address, store) {
    var current_cart, payment_attributes, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
    if (final_error != null) {
      console.error(final_error.stack);
      return socket.emit('cart:place:error', 'Un error impidio la colocación de la orden');
    } else {
      if (me.completed !== true) {
        current_cart = me.toJSON();
        current_cart.cart_products = current_cart_products;
        current_cart.cart_coupons = current_cart_coupons;
        current_cart.client = client.toJSON();
        current_cart.user = user.toJSON();
        current_cart.phone = phone.toJSON();
        current_cart.address = address != null ? address.toJSON() : void 0;
        current_cart.store = store.toJSON();
        current_cart.extra = data;
        payment_attributes = {};
        payment_attributes['payment_type'] = ((_ref = current_cart.extra) != null ? _ref.payment_type : void 0) || null;
        payment_attributes['creditcard_number'] = ((_ref1 = current_cart.extra) != null ? _ref1.cardnumber : void 0) || null;
        payment_attributes['credit_card_approval_number'] = ((_ref2 = current_cart.extra) != null ? _ref2.cardapproval : void 0) || null;
        payment_attributes['fiscal_type'] = ((_ref3 = current_cart.extra) != null ? _ref3.fiscal_type : void 0) || 'FinalConsumer';
        payment_attributes['fiscal_number'] = ((_ref4 = current_cart.extra) != null ? _ref4.rnc : void 0) || null;
        payment_attributes['fiscal_company_name'] = ((_ref5 = current_cart.extra) != null ? _ref5.fiscal_name : void 0) || null;
        return me.updateAttributes(payment_attributes, function(pay_error, cart_with_pay_detailes) {
          if (pay_error) {
            console.error(pay_error.stack);
            return socket.emit('cart:place:error', 'No fue posible actualizar los datos de pago');
          } else {
            return Setting.kapiqua(function(err, settings) {
              var cart_request, pulse_com_error;
              if (err) {
                socket.emit('cart:place:error', 'Falla Lectura de la configuración');
                return console.error(err.stack);
              } else {
                pulse_com_error = function(comm_err) {
                  socket.emit('cart:place:error', 'Falla en la comunicación con Pulse');
                  me.comm_failed(socket, io);
                  return console.error(comm_err.stack);
                };
                cart_request = new PulseBridge(current_cart, current_cart.store.storeid, current_cart.store.ip, settings.pulse_port);
                try {
                  return cart_request.place(pulse_com_error, function(res_data) {
                    var msg, order_reply;
                    console.info(res_data);
                    order_reply = new OrderReply(res_data);
                    console.info(order_reply);
                    if (order_reply.status === '0') {
                      return me.updateAttributes({
                        store_order_id: order_reply.order_id,
                        complete_on: Date.now(),
                        completed: true,
                        message_mask: 1
                      }, function(cart_update_err, updated_cart) {
                        socket.emit('cart:place:completed', updated_cart);
                        return io.sockets["in"]('admins').emit('system:cart:placed', updated_cart);
                      });
                    } else {
                      if (order_reply && order_reply.status_text) {
                        msg = order_reply.status_text;
                      } else {
                        msg = 'La respuesta e pulse no pudo ser interpretada';
                      }
                      return socket.emit('cart:place:error', "No se puede colocar la order, Pulse respondio: <br/> <strong>" + msg + "</strong>");
                    }
                  });
                } catch (err_pricing) {
                  socket.emit('cart:place:error', 'Falla en la comunicación con Pulse');
                  me.comm_failed(socket, io);
                  return console.error(err_pricing.stack);
                }
              }
            });
          }
        });
      } else {
        return socket.emit('cart:place:error', 'Esta orden aparece como completada en el sistema');
      }
    }
  });
};

module.exports = Cart;
