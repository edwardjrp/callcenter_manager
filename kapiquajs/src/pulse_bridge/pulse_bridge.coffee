_ = require('underscore')
request = require('request')
libxml = require("libxmljs")

class PulseBridge
  @debut = false
  @target = 'http://192.168.85.60:59101/RemotePulseAPI/RemotePulseAPI.WSDL'    
  @headers = {"User-Agent": "kapiqua-node" , "Connection": "close","Accept" : "text/html,application/xhtml+xml,application/xml","Accept-Charset": "utf-8", "Content-Type":"text/xml;charset=UTF-8", "SOAPAction": "http://www.dominos.com/action/TestConnection"}
  
  @make: (action, data) ->
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
     xmlns:wsdlns=\"http://www.dominos.com/wsdl/\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ins0=\"http://www.dominos.com/type\">\
     <env:Header><Authorization><FromURI>dominos.com</FromURI><User>TestingAndSupport</User><Password>supp0rtivemeasures</Password><TimeStamp></TimeStamp></Authorization></env:Header>\
     <env:Body><ns1:#{action} xmlns:ns1=\"http://www.dominos.com/message/\" encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">#{data}</ns1:#{action}></env:Body></env:Envelope>"
    
  @send: (action, data, err_cb, cb) ->
    # TestConnection
    # <Value>Hello there</Value>
    body = @make(action, data)
    @headers["Content-Length"] =  body.length
    if @debug == true
      console.log @headers
      console.log body
    request.post {headers: @headers, uri: @target, body: body }, (err, res, res_data) ->
      if err
        err_cb(err)
      else
       cb(res_data)
   
   @price_body: () =>
     doc = new libxml.Document()
     order = new libxml.Element(doc,'Order').attr({orderid:"Order#1317916872", currency:"en-USD", language:"en-USA"})
     order.addChild(new libxml.Element(doc,'StoreID', '15871'))
     order.addChild(new libxml.Element(doc,'ServiceMethod', 'Delivery'))
     order.addChild(new libxml.Element(doc,'OrderTakeSeconds', '60'))
     order.addChild(new libxml.Element(doc,'DeliveryInstructions', 'testing kapiqua25'))
     #order source
     order_source  = new libxml.Element(doc,'OrderSource')
     order_source.addChild(new libxml.Element(doc,'OrganizationURI', 'proteus.dominos.com.do'))
     order_source.addChild(new libxml.Element(doc,'OrderMethod', 'Internet'))
     order_source.addChild(new libxml.Element(doc,'OrderTaker', 'node-js'))
     order.addChild(order_source)
     # end order source
     #customer info
     customer = new libxml.Element(doc,'Customer').attr({'type':'Customer-Standard'})
     customer_address = new libxml.Element(doc,'CustomerAddress').attr({ 'type':"Address-US"})
     customer_address.addChild(new libxml.Element(doc,'City', 'Santo Domingo'))
     customer_address.addChild(new libxml.Element(doc,'Region', ''))
     customer_address.addChild(new libxml.Element(doc,'PostalCode', '15871'))
     customer_address.addChild(new libxml.Element(doc,'StreetNumber', '47'))
     customer_address.addChild(new libxml.Element(doc,'AddressLine2').attr({'xsi:nil':"true"}))
     customer_address.addChild(new libxml.Element(doc,'AddressLine3').attr({'xsi:nil':"true"}))
     customer_address.addChild(new libxml.Element(doc,'AddressLine4').attr({'xsi:nil':"true"}))
     customer_address.addChild(new libxml.Element(doc,'UnitType', 'Apartment'))
     customer_address.addChild(new libxml.Element(doc,'UnitNumber', '202').attr({"xsi:type":"xsd:string"}))
     customer_address.addChild(new libxml.Element(doc,'City', 'Santo Domingo').attr({"xsi:type":"xsd:string"}))
     customer.addChild(customer_address)
     
     customer_name = new libxml.Element(doc,'Name').attr({ 'type':"Name-US"})
     customer_name.addChild(new libxml.Element(doc,'FirstName', 'Jhon'))
     customer_name.addChild(new libxml.Element(doc,'LastName', 'Doe'))
     customer.addChild(customer_name)
     
     customer_type_info = new libxml.Element(doc,'CustomerTypeInfo')
     customer_type_info.addChild(new libxml.Element(doc,'InfoType').attr('xsi:nil':"true"))
     customer_type_info.addChild(new libxml.Element(doc,'OrganizationName').attr('xsi:nil':"true"))
     customer_type_info.addChild(new libxml.Element(doc,'Department').attr('xsi:nil':"true"))
     customer.addChild(customer_type_info)
     
     customer.addChild(new libxml.Element(doc,'Phone', '8095555555'))
     customer.addChild(new libxml.Element(doc,'Extension', ''))
     customer.addChild(new libxml.Element(doc,'Email', 'john@doe.com'))
     customer.addChild(new libxml.Element(doc,'DeliveryInstructions').attr('xsi:nil':"true"))
     customer.addChild(new libxml.Element(doc,'CustomerTax').attr('xsi:nil':"true"))
     
     
     order.addChild(customer)
     
     #end customer info
     #coupons
     order.addChild(new libxml.Element(doc,'Coupons'))
     # end coupons
     #items
     order_items = new libxml.Element(doc,'OrderItems')
     # iteration here
     order_item = new libxml.Element(doc,'OrderItem')
     order_item.addChild(new libxml.Element(doc,'ProductCode', '12SCREEN'))
     order_item.addChild(new libxml.Element(doc,'ProductName').attr('xsi:nil':"true"))
     order_item.addChild(new libxml.Element(doc,'ItemQuantity', '1'))
     order_item.addChild(new libxml.Element(doc,'PricedAt', '0'))
     order_item.addChild(new libxml.Element(doc,'OverrideAmmount').attr('xsi:nil':"true"))
     order_item.addChild(new libxml.Element(doc,'CookingInstructions').attr('xsi:nil':"true"))
     # modifier loop
     item_modifiers = new libxml.Element(doc,'OrderItems')
     # innner modifier loop here
     item_modifier = new libxml.Element(doc,'OrderItem').attr({code:'p'})
     item_modifier.addChild(new libxml.Element(doc,'ItemModifierName').attr('xsi:nil':"true"))
     item_modifier.addChild(new libxml.Element(doc,'ItemModifierQuantity', '1'))
     item_modifier.addChild(new libxml.Element(doc,'ItemModifierPart', 'w'))
     item_modifiers.addChild(item_modifier)
     order.addChild(item_modifiers)
     # end items
     #payment
     payment = new libxml.Element(doc,'Payment')
     cash_payment = new libxml.Element(doc,'CashPayment')
     cash_payment.addChild(new libxml.Element(doc,'PaymentAmmount', '10000'))
     payment.addChild(cash_payment)
     order.addChild(payment)
     #end payment
     
     doc.root(order)
     doc.toString()    
    
console.log PulseBridge.price_body()


module.exports = PulseBridge
