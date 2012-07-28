libxmljs = require("libxmljs")
util = require('util')
_ = require('underscore')

class OrderReply
  constructor: (body) ->
    unless typeof body == 'undefined' or not body?
      doc = libxmljs.parseXmlString(body)
      @reply_id = doc.get('//OrderReply').attr('orderreplyid').value()
      @status = doc.get('//Status').text()
      @status_text = doc.get('//StatusText').text()
      @order_id = doc.get('//StoreOrderID').text() if doc.get('StoreOrderID')?
      @store = doc.get('//StoreID').text()
      @service_method = doc.get('//ServiceMethod').text()
      @can_place = doc.get('//CanPlaceOrder').text()
      @wait_time = doc.get('//EstimatedWaitTime').text()
      @sumary = doc.get('//OrderText').text()
      @order_items = _.map doc.find('//OrderItem'), (order_item)-> new ReplyItem(order_item)
      @sumary = doc.get('//OrderText').text()
      @netamount= doc.get('//NetAmount').text()
      @taxamount= doc.get('//TaxAmount').text()
      @tax1amount= doc.get('//Tax1Amount').text()
      @tax2amount= doc.get('//Tax2Amount').text()
      @payment_amount = doc.get('//PaymentAmount').text()
      


class ReplyItem
  constructor: (order_item)->
    @code = order_item.get('//ProductCode').text()
    @quantity = order_item.get('//ItemQuantity').text()
    @priced_at = order_item.get('//PricedAt').text()
      
module.exports = OrderReply