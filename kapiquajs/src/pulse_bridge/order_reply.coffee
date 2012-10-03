libxmljs = require("libxmljs")
util = require('util')
Option = require('./option')
_ = require('underscore')

class OrderReply
  constructor: (@body, @cart_products) ->
    unless typeof @body == 'undefined' or not @body?
      doc = libxmljs.parseXmlString(@body)
      @reply_id = doc.get('//OrderReply').attr('orderreplyid').value()
      @status = doc.get('//Status').text()
      @status_text = doc.get('//StatusText').text()
      @order_id = doc.get('//StoreOrderID').text() if doc.get('StoreOrderID')?
      @store = doc.get('//StoreID').text()
      @service_method = doc.get('//ServiceMethod').text()
      @can_place = doc.get('//CanPlaceOrder').text()
      @wait_time = doc.get('//EstimatedWaitTime').text()
      @sumary = doc.get('//OrderText').text()
      @order_items = _.map doc.find('//OrderItem'), (order_item)-> 
        new ReplyItem(order_item)
      @sumary = doc.get('//OrderText').text()
      @netamount= doc.get('//NetAmount').text()
      @taxamount= doc.get('//TaxAmount').text()
      @tax1amount= doc.get('//Tax1Amount').text()
      @tax2amount= doc.get('//Tax2Amount').text()
      @payment_amount = doc.get('//PaymentAmount').text()
      

  products: ->
    results = []   
    for order_item in @order_items
      for cart_product in @cart_products
        if order_item.code == cart_product.product.productcode and order_item.quantity == cart_product.quantity.toString() and _.isEmpty(objectDifference(Option.pulseCollection(cart_product.options), order_item.options))
          build_result = { cart_product_id: cart_product.id, product_id: cart_product.product.id, priced_at: order_item.priced_at }
          console.log { cart_product_id: cart_product.id, product_id: cart_product.product.id, priced_at: order_item.priced_at }
          results.push build_result unless objectInclude(results, build_result)
    results


objectIntersection = (array, rest) ->
  result = []
  for i1 in array
    for i2 in rest
      result.push i1 if _.isEqual(i1,i2)
  _.uniq(result)

objectInclude = (array, target) ->
  found = false
  found = _.find(array, (value) ->_.isEqual value, target)
  found?


objectDifference = (array, rest) ->
  result = []
  for i1 in array
    result.push i1 unless objectInclude(rest,i1)
  _.uniq(result)


class ReplyItem
  constructor: (order_item)->
    @code = order_item.childNodes()[0].text()
    @quantity = order_item.childNodes()[2].text()
    @priced_at = order_item.childNodes()[3].text()
    if order_item.childNodes()[4]?
      @options = _.map order_item.childNodes()[4].childNodes(), (item_modifier)->
        quantity = item_modifier.childNodes()[1].text()
        part = item_modifier.childNodes()[2].text()
        code = item_modifier.attr('code').value()
        { quantity: quantity, code: code, part: part }
      
module.exports = OrderReply