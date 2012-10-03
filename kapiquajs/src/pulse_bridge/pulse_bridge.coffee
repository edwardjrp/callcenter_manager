_ = require('underscore')
request = require('request')
libxml = require("libxmljs")
Cart = require('../models/cart')
Product = require('../models/product')
Category = require('../models/category')
async = require('async')
util = require('util')


class PulseBridge

  constructor: (@cart, @storeid, @target_ip, @target_port) ->

  # @debug = false
  target: ->
   "http://#{@target_ip}:#{@target_port}/RemotePulseAPI/RemotePulseAPI.WSDL"
  
  # @make: (action, data) ->
  #   doc = new libxml.Document()


  fallback_values: (action, value, fallback) ->
    if action == 'PlaceOrder'
      value || fallback
    else
      fallback
    
  send: (action, data, err_cb, cb) ->
    headers = { "User-Agent": "kapiqua-node","SOAPAction": "http://www.dominos.com/action/#{action}"  , "Content-Length": data.length, "Connection": "close","Accept" : "text/html,application/xhtml+xml,application/xml","Accept-Charset": "utf-8", "Content-Type":"text/xml;charset=UTF-8" }
    console.info headers
    # console.info @storeid
    # console.info @target()
    # console.info data
    request {method: 'POST', headers: headers, uri: @target(), body: data }, (err, res, res_data) ->
      if err
        console.error err
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
    order = new libxml.Element(doc,'Order').attr({orderid:"Order#1349230038", currency:"en-USD", language:"en-USA"})
    order.addChild(new libxml.Element(doc,'StoreID', "#{@storeid}" ))   # store @storeid 
    order.addChild(new libxml.Element(doc,'ServiceMethod', @fallback_values(action, @cart.service_method,'PickUp')))  # service method
    order.addChild(new libxml.Element(doc,'OrderTakeSeconds', '60'))
    order.addChild(new libxml.Element(doc,'DeliveryInstructions', @fallback_values(action, @cart.delivery_instructions,'Asking for price')))  # delivery instructions
    #order source
    order_source  = new libxml.Element(doc,'OrderSource')
    order_source.addChild(new libxml.Element(doc,'OrganizationURI', 'proteus.dominos.com.do'))
    order_source.addChild(new libxml.Element(doc,'OrderMethod', 'Internet'))
    order_source.addChild(new libxml.Element(doc,'OrderTaker', 'node-js')) # agent idnumber
    order.addChild(order_source)
    # end order source
    #customer info
    customer = new libxml.Element(doc,'Customer').attr({'type':'Customer-Standard'})  # if user has current address set else dummy
    customer_address = new libxml.Element(doc,'CustomerAddress').attr({ 'type':"Address-US"})
    customer_address.addChild(new libxml.Element(doc,'City', 'Santo Domingo')) # city
    customer_address.addChild(new libxml.Element(doc,'Region', ''))
    customer_address.addChild(new libxml.Element(doc,'PostalCode', "#{@storeid}"))
    customer_address.addChild(new libxml.Element(doc,'StreetNumber', '99'))
    customer_address.addChild(new libxml.Element(doc,'StreetName', 'Princing'))
    customer_address.addChild(new libxml.Element(doc,'AddressLine2').attr({'xsi:nil':"true"}))
    customer_address.addChild(new libxml.Element(doc,'AddressLine3').attr({'xsi:nil':"true"}))
    customer_address.addChild(new libxml.Element(doc,'AddressLine4').attr({'xsi:nil':"true"}))
    customer_address.addChild(new libxml.Element(doc,'UnitType', 'Apartment').attr({"xsi:type":"xsd:string"}))
    customer_address.addChild(new libxml.Element(doc,'UnitNumber', '202').attr({"xsi:type":"xsd:string"}))
    customer.addChild(customer_address)
     
    customer_name = new libxml.Element(doc,'Name').attr({ 'type':"Name-US"})
    customer_name.addChild(new libxml.Element(doc,'FirstName', @fallback_values(action, @cart.client?.first_name,'dummy_pricing')))  # user  name
    customer_name.addChild(new libxml.Element(doc,'LastName', @fallback_values(action, @cart.client?.last_name,'dummy_pricing')))  # user last name
    customer.addChild(customer_name)
     
    customer_type_info = new libxml.Element(doc,'CustomerTypeInfo')
    customer_type_info.addChild(new libxml.Element(doc,'InfoType').attr('xsi:nil':"true"))
    customer_type_info.addChild(new libxml.Element(doc,'OrganizationName').attr('xsi:nil':"true"))
    customer_type_info.addChild(new libxml.Element(doc,'Department').attr('xsi:nil':"true"))
    customer.addChild(customer_type_info)
     
    customer.addChild(new libxml.Element(doc,'Phone', @fallback_values(action, @cart.client?.phones?.first?.number,'8095555555')))  # user current phone
    customer.addChild(new libxml.Element(doc,'Extension', @fallback_values(action, @cart.client?.phones?.first?.ext,'99'))) # user current extention - have to check olo for fallback value
    customer.addChild(new libxml.Element(doc,'Email', @fallback_values(action, @cart.client?.email,'none@email.com'))) # user current extention - have to check olo for fallback value
    customer.addChild(new libxml.Element(doc,'DeliveryInstructions').attr('xsi:nil':"true"))
    customer.addChild(new libxml.Element(doc,'CustomerTax').attr('xsi:nil':"true"))
     
     
    order.addChild(customer)
     
    #end customer info
    #coupons
    order.addChild(new libxml.Element(doc,'Coupons')) # coupons population pending
    # end coupons
    #items
    order_items = new libxml.Element(doc,'OrderItems')
    # iteration here
    console.log @cart if action == 'PlaceOrder'

    if _.any(@cart.cart_products)
      for cart_product in @cart.cart_products
        # console.log cart_product
        # console.log cart_product
        order_item = new libxml.Element(doc,'OrderItem')
        order_item.addChild(new libxml.Element(doc,'ProductCode', cart_product.product.productcode))
        order_item.addChild(new libxml.Element(doc,'ProductName').attr('xsi:nil':"true"))
        order_item.addChild(new libxml.Element(doc,'ItemQuantity', (cart_product.quantity.toString() || '1')))
        order_item.addChild(new libxml.Element(doc,'PricedAt', @fallback_values(action, cart_product.priced_at,'0')))
        order_item.addChild(new libxml.Element(doc,'OverrideAmmount').attr('xsi:nil':"true"))
        order_item.addChild(new libxml.Element(doc,'CookingInstructions').attr('xsi:nil':"true"))
        
        item_modifiers = new libxml.Element(doc,'ItemModifiers')
        
        if _.any(cart_product.product_options)
          for product_option in cart_product.product_options             
            item_modifier = new libxml.Element(doc,'ItemModifier').attr({code: product_option.product.productcode})
            item_modifier.addChild(new libxml.Element(doc,'ItemModifierName').attr('xsi:nil':"true"))
            item_modifier.addChild(new libxml.Element(doc,'ItemModifierQuantity', product_option.quantity.toString()))
            item_modifier.addChild(new libxml.Element(doc,'ItemModifierPart', product_option.part))
            item_modifiers.addChild(item_modifier)
        order_item.addChild(item_modifiers)
        order_items.addChild(order_item)
     
    order.addChild(order_items)
    # end items


    #payment   # this whole section depends on the payment menthod - check olo2 cc for handling
    payment = new libxml.Element(doc,'Payment')
    cash_payment = new libxml.Element(doc,'CashPayment')
    cash_payment.addChild(new libxml.Element(doc,'PaymentAmmount', @fallback_values(action, @cart.payment_amount,'1000000')))  # current order for place
    payment.addChild(cash_payment)
    order.addChild(payment)
    #end payment

    orde_info_collection = new libxml.Element(doc,'OrderInfoCollection')
    order_info_1  = new libxml.Element(doc,'OrderInfo')
    order_info_1.addChild(new libxml.Element(doc,'KeyCode',@fallback_values(action, @cart.fiscal_type, 'FinalConsumer')))
    order_info_1.addChild(new libxml.Element(doc,'Response',@fallback_values(action, @cart.fiscal_type, 'FinalConsumer')))
    orde_info_collection.addChild(order_info_1)

    order_info_2  = new libxml.Element(doc,'OrderInfo')
    order_info_2.addChild(new libxml.Element(doc,'KeyCode','TaxID'))
    order_info_2.addChild(new libxml.Element(doc,'Response',@fallback_values(action, @cart.fiscal_number, '')))
    orde_info_collection.addChild(order_info_2)

    order_info_3  = new libxml.Element(doc,'OrderInfo')
    order_info_3.addChild(new libxml.Element(doc,'KeyCode','CompanyName'))
    order_info_3.addChild(new libxml.Element(doc,'Response',@fallback_values(action, @cart.company_name, '')))
    orde_info_collection.addChild(order_info_3)

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
