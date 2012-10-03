var Cart, Category, Product, PulseBridge, async, libxml, request, util, _;

_ = require('underscore');

request = require('request');

libxml = require("libxmljs");

Cart = require('../models/cart');

Product = require('../models/product');

Category = require('../models/category');

async = require('async');

util = require('util');

PulseBridge = (function() {

  function PulseBridge() {}

  PulseBridge.debug = false;

  PulseBridge.target = 'http://192.168.85.60:59101/RemotePulseAPI/RemotePulseAPI.WSDL';

  PulseBridge.headers = {
    "User-Agent": "kapiqua-node",
    "Connection": "close",
    "Accept": "text/html,application/xhtml+xml,application/xml",
    "Accept-Charset": "utf-8",
    "Content-Type": "text/xml;charset=UTF-8"
  };

  PulseBridge.make = function(action, data) {
    var doc;
    return doc = new libxml.Document();
  };

  PulseBridge.fallback_values = function(action, value, fallback) {
    if (action === 'PlaceOrder') {
      return value || fallback;
    } else {
      return fallback;
    }
  };

  PulseBridge.send = function(action, data, err_cb, cb) {
    var body;
    body = data;
    this.headers["Content-Length"] = body.length;
    this.headers["SOAPAction"] = "http://www.dominos.com/action/" + action;
    if (this.debug === true) {
      console.log(this.headers);
    }
    return request({
      method: 'POST',
      headers: this.headers,
      uri: this.target,
      body: body
    }, function(err, res, res_data) {
      if (err) {
        console.log('Before the request handling');
        return err_cb(err);
      } else {
        return cb(res_data);
      }
    });
  };

  PulseBridge.price = function(cart, err_cb, cb) {
    return PulseBridge.send('PriceOrder', PulseBridge.body('PriceOrder', cart), err_cb, cb);
  };

  PulseBridge.place = function(cart, err_cb, cb) {
    return PulseBridge.send('PriceOrder', PulseBridge.body('PlaceOrder', cart), err_cb, cb);
  };

  PulseBridge.body = function(action, cart) {
    var auth, body, cart_product, cash_payment, customer, customer_address, customer_name, customer_type_info, doc, envelope, header, item_modifier, item_modifiers, orde_info_collection, order, order_info_1, order_info_2, order_info_3, order_item, order_items, order_source, payment, product_option, _i, _j, _len, _len1, _ref, _ref1, _ref10, _ref11, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
    doc = new libxml.Document();
    envelope = new libxml.Element(doc, 'env:Envelope').attr({
      'xmlns:xsd': "http://www.w3.org/2001/XMLSchema",
      'xmlns:xsi': "http://www.w3.org/2001/XMLSchema-instance",
      'xmlns:wsdlns': "http://www.dominos.com/wsdl/",
      'xmlns:env': 'http://schemas.xmlsoap.org/soap/envelope/',
      'xmlns:ins0': 'http://www.dominos.com/type'
    });
    header = new libxml.Element(doc, 'env:Header');
    auth = new libxml.Element(doc, 'Authorization');
    auth.addChild(new libxml.Element(doc, 'FromURI', 'dominos.com'));
    auth.addChild(new libxml.Element(doc, 'User', 'TestingAndSupport'));
    auth.addChild(new libxml.Element(doc, 'Password', 'supp0rtivemeasures'));
    auth.addChild(new libxml.Element(doc, 'TimeStamp', ''));
    header.addChild(auth);
    order = new libxml.Element(doc, 'Order').attr({
      orderid: "Order#" + (new Date().getTime()),
      currency: "en-USD",
      language: "en-USA"
    });
    order.addChild(new libxml.Element(doc, 'StoreID', PulseBridge.fallback_values(action, (_ref = cart.store) != null ? _ref.storeid : void 0, '99998')));
    order.addChild(new libxml.Element(doc, 'ServiceMethod', PulseBridge.fallback_values(action, cart.service_method, 'PickUp')));
    order.addChild(new libxml.Element(doc, 'OrderTakeSeconds', '60'));
    order.addChild(new libxml.Element(doc, 'DeliveryInstructions', PulseBridge.fallback_values(action, cart.delivery_instructions, 'Asking for price')));
    order_source = new libxml.Element(doc, 'OrderSource');
    order_source.addChild(new libxml.Element(doc, 'OrganizationURI', 'proteus.dominos.com.do'));
    order_source.addChild(new libxml.Element(doc, 'OrderMethod', 'Internet'));
    order_source.addChild(new libxml.Element(doc, 'OrderTaker', 'node-js'));
    order.addChild(order_source);
    customer = new libxml.Element(doc, 'Customer').attr({
      'type': 'Customer-Standard'
    });
    customer_address = new libxml.Element(doc, 'CustomerAddress').attr({
      'type': "Address-US"
    });
    customer_address.addChild(new libxml.Element(doc, 'City', 'Santo Domingo'));
    customer_address.addChild(new libxml.Element(doc, 'Region', ''));
    customer_address.addChild(new libxml.Element(doc, 'PostalCode', '99998'));
    customer_address.addChild(new libxml.Element(doc, 'StreetNumber', '99'));
    customer_address.addChild(new libxml.Element(doc, 'StreetName', 'Princing'));
    customer_address.addChild(new libxml.Element(doc, 'AddressLine2').attr({
      'xsi:nil': "true"
    }));
    customer_address.addChild(new libxml.Element(doc, 'AddressLine3').attr({
      'xsi:nil': "true"
    }));
    customer_address.addChild(new libxml.Element(doc, 'AddressLine4').attr({
      'xsi:nil': "true"
    }));
    customer_address.addChild(new libxml.Element(doc, 'UnitType', 'Apartment'));
    customer_address.addChild(new libxml.Element(doc, 'UnitNumber', '202').attr({
      "xsi:type": "xsd:string"
    }));
    customer.addChild(customer_address);
    customer_name = new libxml.Element(doc, 'Name').attr({
      'type': "Name-US"
    });
    customer_name.addChild(new libxml.Element(doc, 'FirstName', PulseBridge.fallback_values(action, (_ref1 = cart.client) != null ? _ref1.first_name : void 0, 'dummy_pricing')));
    customer_name.addChild(new libxml.Element(doc, 'LastName', PulseBridge.fallback_values(action, (_ref2 = cart.client) != null ? _ref2.last_name : void 0, 'dummy_pricing')));
    customer.addChild(customer_name);
    customer_type_info = new libxml.Element(doc, 'CustomerTypeInfo');
    customer_type_info.addChild(new libxml.Element(doc, 'InfoType').attr({
      'xsi:nil': "true"
    }));
    customer_type_info.addChild(new libxml.Element(doc, 'OrganizationName').attr({
      'xsi:nil': "true"
    }));
    customer_type_info.addChild(new libxml.Element(doc, 'Department').attr({
      'xsi:nil': "true"
    }));
    customer.addChild(customer_type_info);
    customer.addChild(new libxml.Element(doc, 'Phone', PulseBridge.fallback_values(action, (_ref3 = cart.client) != null ? (_ref4 = _ref3.phones) != null ? (_ref5 = _ref4.first) != null ? _ref5.number : void 0 : void 0 : void 0, '8095555555')));
    customer.addChild(new libxml.Element(doc, 'Extension', PulseBridge.fallback_values(action, (_ref6 = cart.client) != null ? (_ref7 = _ref6.phones) != null ? (_ref8 = _ref7.first) != null ? _ref8.ext : void 0 : void 0 : void 0, '99')));
    customer.addChild(new libxml.Element(doc, 'Email', PulseBridge.fallback_values(action, (_ref9 = cart.client) != null ? _ref9.email : void 0, 'none@email.com')));
    customer.addChild(new libxml.Element(doc, 'DeliveryInstructions').attr({
      'xsi:nil': "true"
    }));
    customer.addChild(new libxml.Element(doc, 'CustomerTax').attr({
      'xsi:nil': "true"
    }));
    order.addChild(customer);
    order.addChild(new libxml.Element(doc, 'Coupons'));
    order_items = new libxml.Element(doc, 'OrderItems');
    if (action === 'PlaceOrder') {
      console.log(cart);
    }
    console.log('GOT HERE');
    if (_.any(cart.cart_products)) {
      _ref10 = cart.cart_products;
      for (_i = 0, _len = _ref10.length; _i < _len; _i++) {
        cart_product = _ref10[_i];
        order_item = new libxml.Element(doc, 'OrderItem');
        order_item.addChild(new libxml.Element(doc, 'ProductCode', cart_product.product.productcode));
        order_item.addChild(new libxml.Element(doc, 'ProductName').attr({
          'xsi:nil': "true"
        }));
        order_item.addChild(new libxml.Element(doc, 'ItemQuantity', cart_product.quantity.toString() || '1'));
        order_item.addChild(new libxml.Element(doc, 'PricedAt', PulseBridge.fallback_values(action, cart_product.priced_at, '0')));
        order_item.addChild(new libxml.Element(doc, 'OverrideAmmount').attr({
          'xsi:nil': "true"
        }));
        order_item.addChild(new libxml.Element(doc, 'CookingInstructions').attr({
          'xsi:nil': "true"
        }));
        item_modifiers = new libxml.Element(doc, 'ItemModifiers');
        if (_.any(cart_product.product_options)) {
          _ref11 = cart_product.product_options;
          for (_j = 0, _len1 = _ref11.length; _j < _len1; _j++) {
            product_option = _ref11[_j];
            item_modifier = new libxml.Element(doc, 'ItemModifier').attr({
              code: product_option.product.productcode
            });
            item_modifier.addChild(new libxml.Element(doc, 'ItemModifierName').attr({
              'xsi:nil': "true"
            }));
            item_modifier.addChild(new libxml.Element(doc, 'ItemModifierQuantity', product_option.quantity.toString()));
            item_modifier.addChild(new libxml.Element(doc, 'ItemModifierPart', product_option.part));
            item_modifiers.addChild(item_modifier);
          }
        }
        order_item.addChild(item_modifiers);
        order_items.addChild(order_item);
      }
    }
    order.addChild(order_items);
    payment = new libxml.Element(doc, 'Payment');
    cash_payment = new libxml.Element(doc, 'CashPayment');
    cash_payment.addChild(new libxml.Element(doc, 'PaymentAmmount', PulseBridge.fallback_values(action, cart.payment_amount, '1000000')));
    payment.addChild(cash_payment);
    order.addChild(payment);
    orde_info_collection = new libxml.Element(doc, 'OrderInfoCollection');
    order_info_1 = new libxml.Element(doc, 'OrderInfo');
    order_info_1.addChild(new libxml.Element(doc, 'KeyCode', PulseBridge.fallback_values(action, cart.fiscal_type, 'FinalConsumer')));
    order_info_1.addChild(new libxml.Element(doc, 'Response', PulseBridge.fallback_values(action, cart.fiscal_type, 'FinalConsumer')));
    orde_info_collection.addChild(order_info_1);
    order_info_2 = new libxml.Element(doc, 'OrderInfo');
    order_info_2.addChild(new libxml.Element(doc, 'KeyCode', 'TaxID'));
    order_info_2.addChild(new libxml.Element(doc, 'Response', PulseBridge.fallback_values(action, cart.fiscal_number, '')));
    orde_info_collection.addChild(order_info_2);
    order_info_3 = new libxml.Element(doc, 'OrderInfo');
    order_info_3.addChild(new libxml.Element(doc, 'KeyCode', 'CompanyName'));
    order_info_3.addChild(new libxml.Element(doc, 'Response', PulseBridge.fallback_values(action, cart.company_name, '')));
    orde_info_collection.addChild(order_info_3);
    order.addChild(orde_info_collection);
    body = new libxml.Element(doc, 'env:Body');
    action = new libxml.Element(doc, "ns1:" + action).attr({
      'xmlns:ns1': "http://www.dominos.com/message/",
      encodingStyle: "http://schemas.xmlsoap.org/soap/encoding/"
    });
    action.addChild(order);
    body.addChild(action);
    envelope.addChild(header);
    envelope.addChild(body);
    doc.root(envelope);
    return doc.toString().replace(/\"/g, '\"');
  };

  return PulseBridge;

}).call(this);

module.exports = PulseBridge;
