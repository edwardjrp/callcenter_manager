var Cart, Category, Option, Product, PulseBridge, async, libxml, request, util, _,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

_ = require('underscore');

request = require('request');

libxml = require("libxmljs");

Cart = require('../models/cart');

Product = require('../models/product');

Category = require('../models/category');

Option = require('./option');

async = require('async');

util = require('util');

PulseBridge = (function() {

  function PulseBridge(cart, storeid, target_ip, target_port) {
    this.cart = cart;
    this.storeid = storeid;
    this.target_ip = target_ip;
    this.target_port = target_port;
    this.body = __bind(this.body, this);

    this.fallback_values = __bind(this.fallback_values, this);

  }

  PulseBridge.prototype.target = function() {
    return "http://" + this.target_ip + ":" + this.target_port + "/RemotePulseAPI/RemotePulseAPI.WSDL";
  };

  PulseBridge.prototype.fallback_values = function(action, value, fallback) {
    if (action === 'PlaceOrder') {
      if (_.isUndefined(value) || _.isNull(value)) {
        return fallback;
      } else {
        return value;
      }
    } else {
      return fallback;
    }
  };

  PulseBridge.prototype.send = function(action, data, err_cb, cb) {
    var headers;
    console.info(this.target());
    console.info(data);
    headers = {
      "User-Agent": "kapiqua-node",
      "SOAPAction": "http://www.dominos.com/action/" + action,
      "Content-Length": data.length,
      "Connection": "close",
      "Accept": "text/html,application/xhtml+xml,application/xml",
      "Accept-Charset": "utf-8",
      "Content-Type": "text/xml;charset=UTF-8"
    };
    console.info(headers);
    return request({
      method: 'POST',
      headers: headers,
      uri: this.target(),
      body: data
    }, function(err, res, res_data) {
      if (err) {
        console.error(err.stack);
        return err_cb(err);
      } else {
        return cb(res_data);
      }
    });
  };

  PulseBridge.prototype.price = function(err_cb, cb) {
    return this.send('PriceOrder', this.body('PriceOrder'), err_cb, cb);
  };

  PulseBridge.prototype.place = function(err_cb, cb) {
    return this.send('PlaceOrder', this.body('PlaceOrder'), err_cb, cb);
  };

  PulseBridge.prototype.body = function(action) {
    var ap, auth, body, cart_coupon, cart_item_price, cart_option_quantity, cart_product, coupon, coupons, customer, customer_address, customer_name, customer_type_info, discount_present, doc, envelope, exoneration_present, header, item_modifier, item_modifiers, orde_info_collection, order, orderOverrrideAmount, order_info_1, order_info_2, order_info_3, order_item, order_items, order_source, payment, payment_type, product_option, product_options, take_time, tax, tc, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref17, _ref18, _ref19, _ref2, _ref20, _ref21, _ref22, _ref23, _ref24, _ref25, _ref26, _ref27, _ref28, _ref29, _ref3, _ref30, _ref31, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
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
      orderid: "Order#" + (Date.now()),
      currency: "en-USD",
      language: "en-USA"
    });
    order.addChild(new libxml.Element(doc, 'StoreID', "" + this.storeid));
    order.addChild(new libxml.Element(doc, 'ServiceMethod', this.fallback_values(action, this.cart.service_method, 'dinein')));
    take_time = (Date.now() - Date.parse(this.cart.started_on)) / 1000;
    if (take_time > 9999) {
      take_time = 9999;
    }
    take_time;

    order.addChild(new libxml.Element(doc, 'OrderTakeSeconds', this.fallback_values(action, take_time.toString(), '60')));
    tc = this.fallback_values(action, (_ref = this.cart.extra) != null ? _ref.cardnumber : void 0, 'N/A');
    ap = this.fallback_values(action, (_ref1 = this.cart.extra) != null ? _ref1.cardapproval : void 0, 'N/A');
    if ((this.cart.extra != null) && (this.cart.extra.fiscal_type != null)) {
      switch (this.cart.extra.fiscal_type) {
        case "3rdParty":
          tax = "CF:CredFiscal;RNC:" + this.cart.extra.rnc;
          break;
        case "SpecialRegme":
          tax = "CF:RegEspecial;RNC:" + this.cart.extra.rnc;
          break;
        case "Government":
          tax = "CF:Government;RNC:" + this.cart.extra.rnc;
          break;
        default:
          tax = 'CF:ConsFinal';
      }
    }
    order.addChild(new libxml.Element(doc, 'DeliveryInstructions', "Edf:;TC:" + (tc.toString()) + ";AP:" + (ap.toString()) + ";" + (this.fallback_values(action, tax, 'CF:ConsFinal')) + ";D_I."));
    order_source = new libxml.Element(doc, 'OrderSource');
    order_source.addChild(new libxml.Element(doc, 'OrganizationURI', 'proteus.dominos.com.do'));
    order_source.addChild(new libxml.Element(doc, 'OrderMethod', 'Internet'));
    order_source.addChild(new libxml.Element(doc, 'OrderTaker', "" + ((_ref2 = this.cart.user) != null ? _ref2.first_name : void 0) + " " + ((_ref3 = this.cart.user) != null ? _ref3.last_name : void 0)));
    order.addChild(order_source);
    customer = new libxml.Element(doc, 'Customer').attr({
      'type': 'Customer-Standard'
    });
    customer_address = new libxml.Element(doc, 'CustomerAddress').attr({
      'type': "Address-US"
    });
    if (action === 'PlaceOrder' && (this.cart.address != null) && this.cart.service_method === 'delivery') {
      customer_address.addChild(new libxml.Element(doc, 'City', this.fallback_values(action, (_ref4 = this.cart.extra) != null ? _ref4.city : void 0, 'Santo Domingo')));
      customer_address.addChild(new libxml.Element(doc, 'Region', 'DR'));
      customer_address.addChild(new libxml.Element(doc, 'PostalCode', this.fallback_values(action, (_ref5 = this.cart.address) != null ? (_ref6 = _ref5.postal_code) != null ? _ref6.toString() : void 0 : void 0, "" + this.storeid)));
      customer_address.addChild(new libxml.Element(doc, 'StreetNumber', this.fallback_values(action, (_ref7 = this.cart.address) != null ? (_ref8 = _ref7.number) != null ? _ref8.toString() : void 0 : void 0, "")));
      customer_address.addChild(new libxml.Element(doc, 'StreetName', this.fallback_values(action, "" + ((_ref9 = this.cart.extra) != null ? _ref9.street : void 0) + ", " + ((_ref10 = this.cart.extra) != null ? _ref10.area : void 0), "")));
      customer_address.addChild(new libxml.Element(doc, 'AddressLine2'));
      customer_address.addChild(new libxml.Element(doc, 'AddressLine3'));
      customer_address.addChild(new libxml.Element(doc, 'AddressLine4'));
      customer_address.addChild(new libxml.Element(doc, 'UnitType', this.fallback_values(action, (_ref11 = this.cart.address) != null ? _ref11.unit_type : void 0, "")).attr({
        "xsi:type": "xsd:string"
      }));
      customer_address.addChild(new libxml.Element(doc, 'UnitNumber', this.fallback_values(action, (_ref12 = this.cart.address) != null ? (_ref13 = _ref12.unit_number) != null ? _ref13.toString() : void 0 : void 0, "")).attr({
        "xsi:type": "xsd:string"
      }));
    } else {
      customer_address.addChild(new libxml.Element(doc, 'City'));
      customer_address.addChild(new libxml.Element(doc, 'Region'));
      customer_address.addChild(new libxml.Element(doc, 'PostalCode'));
      customer_address.addChild(new libxml.Element(doc, 'StreetNumber'));
      customer_address.addChild(new libxml.Element(doc, 'StreetName'));
      customer_address.addChild(new libxml.Element(doc, 'AddressLine2'));
      customer_address.addChild(new libxml.Element(doc, 'AddressLine3'));
      customer_address.addChild(new libxml.Element(doc, 'AddressLine4'));
      customer_address.addChild(new libxml.Element(doc, 'UnitType'));
      customer_address.addChild(new libxml.Element(doc, 'UnitNumber'));
    }
    customer.addChild(customer_address);
    customer_name = new libxml.Element(doc, 'Name').attr({
      'type': "Name-US"
    });
    customer_name.addChild(new libxml.Element(doc, 'FirstName', this.fallback_values(action, (_ref14 = this.cart.client) != null ? _ref14.first_name : void 0, 'dummy_pricing')));
    customer_name.addChild(new libxml.Element(doc, 'LastName', this.fallback_values(action, (_ref15 = this.cart.client) != null ? _ref15.last_name : void 0, 'dummy_last_pricing')));
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
    customer.addChild(new libxml.Element(doc, 'Phone', this.fallback_values(action, (_ref16 = this.cart.phone) != null ? _ref16.number.toString() : void 0, '8095559999')));
    customer.addChild(new libxml.Element(doc, 'Extension', this.fallback_values(action, (_ref17 = this.cart.phone) != null ? (_ref18 = _ref17.ext) != null ? _ref18.toString() : void 0 : void 0, '')));
    customer.addChild(new libxml.Element(doc, 'Email', this.fallback_values(action, (_ref19 = this.cart.client) != null ? _ref19.email : void 0, 'test@mail.com')));
    customer.addChild(new libxml.Element(doc, 'DeliveryInstructions').attr({
      'xsi:nil': "true"
    }));
    customer.addChild(new libxml.Element(doc, 'CustomerTax').attr({
      'xsi:nil': "true"
    }));
    order.addChild(customer);
    coupons = new libxml.Element(doc, 'Coupons');
    if (_.any(this.cart.cart_coupons)) {
      _ref20 = this.cart.cart_coupons;
      for (_i = 0, _len = _ref20.length; _i < _len; _i++) {
        cart_coupon = _ref20[_i];
        coupon = new libxml.Element(doc, 'Coupon');
        coupon.addChild(new libxml.Element(doc, 'Code', cart_coupon.code));
        coupon.addChild(new libxml.Element(doc, 'approximateMaximumDiscountAmount').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'couponProducts').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'description').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'discountAmount').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'discountValue').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'effectiveDate').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'effectiveDays').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'effectiveTime').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'expirationDate').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'expirationTime').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'generatedDescription').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'hidden').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'minimumPrice').attr({
          'xsi:nil': "true"
        }));
        coupon.addChild(new libxml.Element(doc, 'serviceMethods').attr({
          'xsi:nil': "true"
        }));
        coupons.addChild(coupon);
      }
    }
    order.addChild(coupons);
    order_items = new libxml.Element(doc, 'OrderItems');
    if (_.any(this.cart.cart_products)) {
      _ref21 = this.cart.cart_products;
      for (_j = 0, _len1 = _ref21.length; _j < _len1; _j++) {
        cart_product = _ref21[_j];
        order_item = new libxml.Element(doc, 'OrderItem');
        order_item.addChild(new libxml.Element(doc, 'ProductCode', cart_product.product.productcode));
        order_item.addChild(new libxml.Element(doc, 'ProductName').attr({
          'xsi:nil': "true"
        }));
        order_item.addChild(new libxml.Element(doc, 'ItemQuantity', cart_product.quantity.toString() || '1'));
        if (cart_product.priced_at != null) {
          cart_item_price = cart_product.priced_at.toString();
        } else {
          cart_item_price = '0';
        }
        order_item.addChild(new libxml.Element(doc, 'PricedAt', this.fallback_values(action, cart_item_price, '0')));
        order_item.addChild(new libxml.Element(doc, 'OverrideAmount').attr({
          'xsi:nil': "true"
        }));
        order_item.addChild(new libxml.Element(doc, 'CookingInstructions').attr({
          'xsi:nil': "true"
        }));
        item_modifiers = new libxml.Element(doc, 'ItemModifiers');
        product_options = Option.collection(cart_product.options);
        if (_.any(product_options)) {
          for (_k = 0, _len2 = product_options.length; _k < _len2; _k++) {
            product_option = product_options[_k];
            item_modifier = new libxml.Element(doc, 'ItemModifier').attr({
              code: product_option.code()
            });
            item_modifier.addChild(new libxml.Element(doc, 'ItemModifierName').attr({
              'xsi:nil': "true"
            }));
            if (product_option.quantity() != null) {
              cart_option_quantity = product_option.quantity().toString();
            } else {
              cart_option_quantity = '0';
            }
            item_modifier.addChild(new libxml.Element(doc, 'ItemModifierQuantity', cart_option_quantity));
            item_modifier.addChild(new libxml.Element(doc, 'ItemModifierPart', product_option.part()));
            item_modifiers.addChild(item_modifier);
          }
        }
        order_item.addChild(item_modifiers);
        order_items.addChild(order_item);
      }
    }
    order.addChild(order_items);
    payment = new libxml.Element(doc, 'Payment');
    payment_type = new libxml.Element(doc, this.fallback_values(action, (_ref22 = this.cart.extra) != null ? _ref22.payment_type : void 0, 'CashPayment'));
    payment_type.addChild(new libxml.Element(doc, 'PaymentAmmount', this.fallback_values(action, (_ref23 = this.cart.payment_amount) != null ? _ref23.toString() : void 0, '1000000')));
    if (this.fallback_values(action, (_ref24 = this.cart.extra) != null ? _ref24.payment_type : void 0, 'CashPayment') === 'CreditCardPayment') {
      payment_type.addChild(new libxml.Element(doc, "CreditCardType", 'Mastercard'));
      payment_type.addChild(new libxml.Element(doc, "CreditCardTypeId", '7'));
    }
    payment.addChild(payment_type);
    order.addChild(payment);
    discount_present = this.cart.discount && !_.isNull(this.cart.discount_auth_id) && !_.isUndefined(this.cart.discount_auth_id);
    exoneration_present = this.cart.exonerated && this.cart.exonerated === true && !_.isNull(this.cart.exoneration_authorizer) && !_.isUndefined(this.cart.exoneration_authorizer);
    orderOverrrideAmount = this.cart.payment_amount;
    if (this.cart.payment_amount != null) {
      if (exoneration_present) {
        orderOverrrideAmount = Number(orderOverrrideAmount) - Number(this.cart.tax_amount);
      }
      if (discount_present) {
        orderOverrrideAmount = Number(orderOverrrideAmount) - Number(this.cart.discount);
      }
      if (orderOverrrideAmount < 1) {
        orderOverrrideAmount = this.cart.payment_amount;
      }
    }
    if (discount_present || exoneration_present) {
      order.addChild(new libxml.Element(doc, 'OrderOverrideAmount', orderOverrrideAmount.toString()));
    }
    orde_info_collection = new libxml.Element(doc, 'OrderInfoCollection');
    order_info_1 = new libxml.Element(doc, 'OrderInfo');
    order_info_1.addChild(new libxml.Element(doc, 'KeyCode', this.fallback_values(action, (_ref25 = this.cart.extra) != null ? _ref25.fiscal_type : void 0, 'FinalConsumer')));
    order_info_1.addChild(new libxml.Element(doc, 'Response', this.fallback_values(action, (_ref26 = this.cart.extra) != null ? _ref26.fiscal_type : void 0, 'FinalConsumer')));
    orde_info_collection.addChild(order_info_1);
    if ((((_ref27 = this.cart.extra) != null ? _ref27.fiscal_type : void 0) != null) && ((_ref28 = this.cart.extra) != null ? _ref28.fiscal_type : void 0) !== 'FinalConsumer') {
      order_info_2 = new libxml.Element(doc, 'OrderInfo');
      order_info_2.addChild(new libxml.Element(doc, 'KeyCode', 'TaxID'));
      order_info_2.addChild(new libxml.Element(doc, 'Response', this.fallback_values(action, (_ref29 = this.cart.extra) != null ? (_ref30 = _ref29.rnc) != null ? _ref30.toString() : void 0 : void 0, '')));
      orde_info_collection.addChild(order_info_2);
      order_info_3 = new libxml.Element(doc, 'OrderInfo');
      order_info_3.addChild(new libxml.Element(doc, 'KeyCode', 'CompanyName'));
      order_info_3.addChild(new libxml.Element(doc, 'Response', this.fallback_values(action, (_ref31 = this.cart.extra) != null ? _ref31.fiscal_name : void 0, '')));
      orde_info_collection.addChild(order_info_3);
    }
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

})();

module.exports = PulseBridge;
