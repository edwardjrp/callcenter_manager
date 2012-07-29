var OrderReply, ReplyItem, libxmljs, util, _;

libxmljs = require("libxmljs");

util = require('util');

_ = require('underscore');

OrderReply = (function() {

  function OrderReply(body) {
    var doc;
    if (!(typeof body === 'undefined' || !(body != null))) {
      doc = libxmljs.parseXmlString(body);
      this.reply_id = doc.get('//OrderReply').attr('orderreplyid').value();
      this.status = doc.get('//Status').text();
      this.status_text = doc.get('//StatusText').text();
      if (doc.get('StoreOrderID') != null) {
        this.order_id = doc.get('//StoreOrderID').text();
      }
      this.store = doc.get('//StoreID').text();
      this.service_method = doc.get('//ServiceMethod').text();
      this.can_place = doc.get('//CanPlaceOrder').text();
      this.wait_time = doc.get('//EstimatedWaitTime').text();
      this.sumary = doc.get('//OrderText').text();
      this.order_items = _.map(doc.find('//OrderItem'), function(order_item) {
        return new ReplyItem(order_item);
      });
      this.sumary = doc.get('//OrderText').text();
      this.netamount = doc.get('//NetAmount').text();
      this.taxamount = doc.get('//TaxAmount').text();
      this.tax1amount = doc.get('//Tax1Amount').text();
      this.tax2amount = doc.get('//Tax2Amount').text();
      this.payment_amount = doc.get('//PaymentAmount').text();
    }
  }

  return OrderReply;

})();

ReplyItem = (function() {

  function ReplyItem(order_item) {
    this.code = order_item.childNodes()[0].text();
    this.quantity = order_item.childNodes()[2].text();
    this.priced_at = order_item.childNodes()[3].text();
    if (order_item.childNodes()[4] != null) {
      this.options = _.map(order_item.childNodes()[4].childNodes(), function(item_modifier) {
        var part, quantity;
        if (item_modifier.childNodes()[1].text() === '1') {
          quantity = '';
        } else {
          quantity = item_modifier.childNodes()[1].text();
        }
        if ((item_modifier.childNodes()[2] != null) && item_modifier.childNodes()[2].text().match(/1|2/)) {
          part = "-" + (item_modifier.childNodes()[2].text());
        } else {
          part = '';
        }
        return "" + quantity + (item_modifier.attr('code').value()) + part;
      });
    }
  }

  return ReplyItem;

})();

module.exports = OrderReply;
