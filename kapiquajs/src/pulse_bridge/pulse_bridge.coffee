_ = require('underscore')
request = require('request')
libxml = require("libxmljs")
Cart = require('../models/cart')
Product = require('../models/product')
Category = require('../models/category')
Option = require('./option')
async = require('async')
util = require('util')


class PulseBridge

  constructor: (@cart, @storeid, @target_ip, @target_port) ->

  # @debug = false
  target: ->
    "http://#{@target_ip}:#{@target_port}/RemotePulseAPI/RemotePulseAPI.WSDL"
  
  # @make: (action, data) ->
  #   doc = new libxml.Document()


  fallback_values: (action, value, fallback) =>
    if action == 'PlaceOrder'
      if not value? or _.isUndefined(value) then fallback else value
    else
      fallback
    
  send: (action, data, err_cb, cb) ->
    console.info @target()
    console.info data
    headers = { "User-Agent": "kapiqua-node","SOAPAction": "http://www.dominos.com/action/#{action}"  , "Content-Length": data.length, "Connection": "close","Accept" : "text/html,application/xhtml+xml,application/xml","Accept-Charset": "utf-8", "Content-Type":"text/xml;charset=UTF-8" }
    console.info headers
    # console.info @storeid
    # console.info @target()
    # console.info data
    request {method: 'POST', headers: headers, uri: @target(), body: data }, (err, res, res_data) ->
      if err
        console.error err.stack
        err_cb(err)
      else
        cb(res_data)
  
  price: (err_cb, cb) ->
    @send('PriceOrder', @body('PriceOrder'), err_cb, cb)

  place: (err_cb, cb) ->
    @send('PlaceOrder', @body('PlaceOrder'), err_cb, cb)
     
  body: (action) =>
    doc = new libxml.Document()
    envelope = new libxml.Element(doc,'env:Envelope').attr
      'xmlns:xsd':"http://www.w3.org/2001/XMLSchema"
      'xmlns:xsi':"http://www.w3.org/2001/XMLSchema-instance"
      'xmlns:wsdlns':"http://www.dominos.com/wsdl/"
      'xmlns:env':'http://schemas.xmlsoap.org/soap/envelope/'
      'xmlns:ins0':'http://www.dominos.com/type'
    header = new libxml.Element(doc,'env:Header')
    auth = new libxml.Element(doc,'Authorization')
    auth.addChild(new libxml.Element(doc,'FromURI', 'dominos.com'))
    auth.addChild(new libxml.Element(doc,'User', 'TestingAndSupport'))
    auth.addChild(new libxml.Element(doc,'Password', 'supp0rtivemeasures'))
    auth.addChild(new libxml.Element(doc,'TimeStamp',''))
    header.addChild(auth)
    # #{new Date().getTime()}
    # 1349230038
    order = new libxml.Element(doc,'Order').attr({orderid:"Order##{Date.now()}", currency:"en-USD", language:"en-USA"})
    order.addChild(new libxml.Element(doc,'StoreID', "#{@storeid}" ))   # store @storeid 
    # order.addChild(new libxml.Element(doc,'ServiceMethod', @fallback_values(action, @cart.service_method, 'delivery')))  # service method
    order.addChild(new libxml.Element(doc,'ServiceMethod', @fallback_values(action, @cart.service_method, 'dinein')))  # service method

    take_time = (Date.now() - Date.parse(@cart.started_on))/1000
    take_time
    order.addChild(new libxml.Element(doc,'OrderTakeSeconds',@fallback_values(action, take_time.toString(), '60')))
    order.addChild(new libxml.Element(doc,'DeliveryInstructions', 'Edf:;TC:N/A;AP:N/A;D_I.'))  # delivery instructions
    #order source
    order_source  = new libxml.Element(doc,'OrderSource')
    order_source.addChild(new libxml.Element(doc,'OrganizationURI', 'proteus.dominos.com.do'))
    order_source.addChild(new libxml.Element(doc,'OrderMethod', 'Internet'))
    order_source.addChild(new libxml.Element(doc,'OrderTaker', 'node-js')) # agent idnumber
    order.addChild(order_source)
    # end order source
    #customer info
    console.log 'DONT FORGET TO ADD USER ADDRESS HERE!!!'
    customer = new libxml.Element(doc,'Customer').attr({'type':'Customer-Standard'})  # if user has current address set else dummy
    customer_address = new libxml.Element(doc,'CustomerAddress').attr({ 'type':"Address-US"})
    customer_address.addChild(new libxml.Element(doc,'City', 'Santo Domingo')) # city
    customer_address.addChild(new libxml.Element(doc,'Region', 'DR'))
    customer_address.addChild(new libxml.Element(doc,'PostalCode', "#{@storeid}"))
    customer_address.addChild(new libxml.Element(doc,'StreetNumber', '99'))
    customer_address.addChild(new libxml.Element(doc,'StreetName', 'Princing'))
    customer_address.addChild(new libxml.Element(doc,'AddressLine2'))
    customer_address.addChild(new libxml.Element(doc,'AddressLine3'))
    customer_address.addChild(new libxml.Element(doc,'AddressLine4'))
    customer_address.addChild(new libxml.Element(doc,'UnitType', 'Apartment').attr({"xsi:type":"xsd:string"}))
    customer_address.addChild(new libxml.Element(doc,'UnitNumber', '').attr({"xsi:type":"xsd:string"}))
    customer.addChild(customer_address)
     
    customer_name = new libxml.Element(doc,'Name').attr({ 'type':"Name-US"})
    customer_name.addChild(new libxml.Element(doc,'FirstName', @fallback_values(action, @cart.client?.first_name,'dummy_pricing')))  # user  name
    customer_name.addChild(new libxml.Element(doc,'LastName', @fallback_values(action, @cart.client?.last_name,'dummy_last_pricing')))  # user last name
    customer.addChild(customer_name)
     
    customer_type_info = new libxml.Element(doc,'CustomerTypeInfo')
    customer_type_info.addChild(new libxml.Element(doc,'InfoType').attr('xsi:nil':"true"))
    customer_type_info.addChild(new libxml.Element(doc,'OrganizationName').attr('xsi:nil':"true"))
    customer_type_info.addChild(new libxml.Element(doc,'Department').attr('xsi:nil':"true"))
    customer.addChild(customer_type_info)
     
    customer.addChild(new libxml.Element(doc,'Phone', @fallback_values(action, @cart.client?.phones?.first?.number,'8095656322')))  # user current phone
    customer.addChild(new libxml.Element(doc,'Extension',@fallback_values(action, @cart.client?.phones?.first?.number,'99'))) # user current extention
    customer.addChild(new libxml.Element(doc,'Email', 'test@mail.com')) # user current extention - have to check olo for fallback value
    customer.addChild(new libxml.Element(doc,'DeliveryInstructions').attr('xsi:nil':"true"))
    customer.addChild(new libxml.Element(doc,'CustomerTax').attr('xsi:nil':"true"))
     
     
    order.addChild(customer)
     
    #end customer info
    #coupons

    # order.addChild(new libxml.Element(doc,'Coupons')) # coupons population pending
    coupons = new libxml.Element(doc,'Coupons')
    # console.log @cart.cart_coupons
    if _.any(@cart.cart_coupons)
      for cart_coupon in @cart.cart_coupons
        coupon = new libxml.Element(doc,'Coupon')
        coupon.addChild(new libxml.Element(doc,'Code', cart_coupon.code))
        coupon.addChild(new libxml.Element(doc,'approximateMaximumDiscountAmount').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'couponProducts').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'description').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'discountAmount').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'discountValue').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'effectiveDate').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'effectiveDays').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'effectiveTime').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'expirationDate').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'expirationTime').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'generatedDescription').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'hidden').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'minimumPrice').attr('xsi:nil':"true"))
        coupon.addChild(new libxml.Element(doc,'serviceMethods').attr('xsi:nil':"true"))
        coupons.addChild(coupon)
    order.addChild(coupons)

    # end coupons
    #items
    order_items = new libxml.Element(doc,'OrderItems')
    # iteration here
    # console.log @cart if action == 'PlaceOrder'

    if _.any(@cart.cart_products)
      for cart_product in @cart.cart_products
        # console.log cart_product
        # console.log cart_product
        order_item = new libxml.Element(doc,'OrderItem')
        order_item.addChild(new libxml.Element(doc,'ProductCode', cart_product.product.productcode))
        order_item.addChild(new libxml.Element(doc,'ProductName').attr('xsi:nil':"true"))
        order_item.addChild(new libxml.Element(doc,'ItemQuantity', (cart_product.quantity.toString() || '1')))
        if cart_product.priced_at? then cart_item_price = cart_product.priced_at.toString() else cart_item_price = '0'
        order_item.addChild(new libxml.Element(doc,'PricedAt', @fallback_values(action, cart_item_price,'0')))# @fallback_values(action, cart_product.priced_at,'0')
        order_item.addChild(new libxml.Element(doc,'OverrideAmmount').attr('xsi:nil':"true"))
        order_item.addChild(new libxml.Element(doc,'CookingInstructions').attr('xsi:nil':"true"))
        
        item_modifiers = new libxml.Element(doc,'ItemModifiers')
        product_options = Option.collection(cart_product.options)
        # console.log product_options
        if _.any(product_options)
          for product_option in product_options             
            item_modifier = new libxml.Element(doc,'ItemModifier').attr({code: product_option.code()})
            item_modifier.addChild(new libxml.Element(doc,'ItemModifierName').attr('xsi:nil':"true"))
            if product_option.quantity()?  then cart_option_quantity = product_option.quantity().toString() else cart_option_quantity = '0'
            item_modifier.addChild(new libxml.Element(doc,'ItemModifierQuantity', cart_option_quantity ))
            item_modifier.addChild(new libxml.Element(doc,'ItemModifierPart', product_option.part()))
            item_modifiers.addChild(item_modifier)
        order_item.addChild(item_modifiers)
        order_items.addChild(order_item)
     
    order.addChild(order_items)
    # end items


    #payment   # this whole section depends on the payment menthod - check olo2 cc for handling
    payment = new libxml.Element(doc,'Payment')
    cash_payment = new libxml.Element(doc,'CashPayment',  @fallback_values(action, @cart.payment_amount,'1000000'))
    # console.log 'HERE\n\n\n\n\n'
    # console.log @cart.payment_amount
    # cash_payment.addChild(new libxml.Element(doc,'PaymentAmmount', '360'))  # current order for place  @fallback_values(action, @cart.payment_amount.toString(),'1000000'))
    payment.addChild(cash_payment)
    order.addChild(payment)
    #end payment

    orde_info_collection = new libxml.Element(doc,'OrderInfoCollection')
    order_info_1  = new libxml.Element(doc,'OrderInfo')
    order_info_1.addChild(new libxml.Element(doc,'KeyCode',@fallback_values(action, @cart.fiscal_type, 'FinalConsumer')))
    order_info_1.addChild(new libxml.Element(doc,'Response',@fallback_values(action, @cart.fiscal_type, 'FinalConsumer')))
    orde_info_collection.addChild(order_info_1)

    # order_info_2  = new libxml.Element(doc,'OrderInfo')
    # order_info_2.addChild(new libxml.Element(doc,'KeyCode','TaxID'))
    # order_info_2.addChild(new libxml.Element(doc,'Response',@fallback_values(action, @cart.fiscal_number, '')))
    # orde_info_collection.addChild(order_info_2)

    # order_info_3  = new libxml.Element(doc,'OrderInfo')
    # order_info_3.addChild(new libxml.Element(doc,'KeyCode','CompanyName'))
    # order_info_3.addChild(new libxml.Element(doc,'Response',@fallback_values(action, @cart.company_name, '')))
    # orde_info_collection.addChild(order_info_3)

    order.addChild(orde_info_collection)



     
    body = new libxml.Element(doc,'env:Body')
    action = new libxml.Element(doc, "ns1:#{action}").attr({ 'xmlns:ns1':"http://www.dominos.com/message/", encodingStyle:"http://schemas.xmlsoap.org/soap/encoding/"})
    action.addChild(order)
    body.addChild(action)
    envelope.addChild(header)
    envelope.addChild(body) 
    doc.root(envelope)
    # console.log doc.toString()
    doc.toString().replace(/\"/g, '\"')
    

module.exports = PulseBridge
