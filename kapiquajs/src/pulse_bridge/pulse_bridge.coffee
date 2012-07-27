_ = require('underscore')
request = require('request')
libxml = require("libxmljs")

class PulseBridge
  @debut = false
  @target = 'http://192.168.85.60:59101/RemotePulseAPI/RemotePulseAPI.WSDL'    
  @headers = {"User-Agent": "kapiqua-node" , "Connection": "close","Accept" : "text/html,application/xhtml+xml,application/xml","Accept-Charset": "utf-8", "Content-Type":"text/xml;charset=UTF-8"}
  
  @cart = cart = {"advance_order_time":null,"business_date":null,"can_place_order":null,"client_id":null,"communication_failed":false,"company_name":null,"completed":false,"created_at":"2012-07-17T23:51:52-04:00","credit_cart_approval_name":null,"delivery_instructions":null,"discount":null,"discount_auth_id":null,"fiscal_number":null,"fiscal_type":null,"id":1,"message":null,"net_amount":null,"order_progress":null,"order_text":null,"payment_amount":null,"payment_type":null,"service_method":null,"status_text":null,"store_id":null,"store_order_id":null,"tax1_amount":null,"tax2_amount":null,"tax_amount":null,"updated_at":"2012-07-17T23:51:52-04:00","user_id":1,"cart_products":[{"bind_id":180,"cart_id":1,"created_at":"2012-07-24T21:57:33-04:00","id":80,"options":"C-1,X,1.5C-2,G-2,M-2,O-2,R-2","product_id":173,"quantity":3,"updated_at":"2012-07-24T21:57:33-04:00","product":{"category_id":7,"created_at":"2012-07-17T23:34:24-04:00","flavorcode":"DEEPDISH","id":173,"options":"X,C","optionselectiongrouptype":"PIZZA","productcode":"14PAN","productname":"14&quot; Gordita Napolitana","productoptionselectiongroup":"PIZZA","sizecode":"14","updated_at":"2012-07-17T23:34:24-04:00"}},{"bind_id":null,"cart_id":1,"created_at":"2012-07-24T22:00:24-04:00","id":81,"options":"undefinedC-1,undefinedH-1,2X-1","product_id":168,"quantity":1,"updated_at":"2012-07-24T22:00:24-04:00","product":{"category_id":7,"created_at":"2012-07-17T23:34:24-04:00","flavorcode":"DEEPDISH","id":168,"options":"X,1.5C,1.5H","optionselectiongrouptype":"PIZJX","productcode":"14FHDD","productname":"14&quot; Gordita Fiesta de Jamon","productoptionselectiongroup":"PIZJX","sizecode":"14","updated_at":"2012-07-17T23:34:24-04:00"}},{"bind_id":179,"cart_id":1,"created_at":"2012-07-24T22:00:27-04:00","id":82,"options":"1.5C-1,1.5H-1,X,C-2,1.5P-2","product_id":168,"quantity":6,"updated_at":"2012-07-24T22:00:34-04:00","product":{"category_id":7,"created_at":"2012-07-17T23:34:24-04:00","flavorcode":"DEEPDISH","id":168,"options":"X,1.5C,1.5H","optionselectiongrouptype":"PIZJX","productcode":"14FHDD","productname":"14&quot; Gordita Fiesta de Jamon","productoptionselectiongroup":"PIZJX","sizecode":"14","updated_at":"2012-07-17T23:34:24-04:00"}},{"bind_id":null,"cart_id":1,"created_at":"2012-07-24T13:04:13-04:00","id":77,"options":"2C-1,2X-1","product_id":173,"quantity":4,"updated_at":"2012-07-24T22:15:31-04:00","product":{"category_id":7,"created_at":"2012-07-17T23:34:24-04:00","flavorcode":"DEEPDISH","id":173,"options":"X,C","optionselectiongrouptype":"PIZZA","productcode":"14PAN","productname":"14&quot; Gordita Napolitana","productoptionselectiongroup":"PIZZA","sizecode":"14","updated_at":"2012-07-17T23:34:24-04:00"}}]}
  
  @make: (action, data) ->
    doc = new libxml.Document()    
    
  @send: (action, data, err_cb, cb) ->
    # TestConnection
    # <Value>Hello there</Value>
    body = data
    # console.log body
    @headers["Content-Length"] =  body.length
    @headers["SOAPAction"]= "http://www.dominos.com/action/#{action}"
    if @debug == true
      console.log @headers
      console.log body
    request.post {headers: @headers, uri: @target, body: body }, (err, res, res_data) ->
      if err
        err_cb(err)
      else
       cb(res_data)
  
  
  
   @price: (err_cb, cb) ->
     PulseBridge.send('PriceOrder', PulseBridge.body('PriceOrder'), err_cb, cb)    
         
   @body: (action, cart) =>
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
     
     order = new libxml.Element(doc,'Order').attr({orderid:"Order#1317916872", currency:"en-USD", language:"en-USA"})
     order.addChild(new libxml.Element(doc,'StoreID', '99998'))
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
     customer_address.addChild(new libxml.Element(doc,'PostalCode', '99998'))
     customer_address.addChild(new libxml.Element(doc,'StreetNumber', '47'))
     customer_address.addChild(new libxml.Element(doc,'AddressLine2').attr({'xsi:nil':"true"}))
     customer_address.addChild(new libxml.Element(doc,'AddressLine3').attr({'xsi:nil':"true"}))
     customer_address.addChild(new libxml.Element(doc,'AddressLine4').attr({'xsi:nil':"true"}))
     customer_address.addChild(new libxml.Element(doc,'UnitType', 'Apartment'))
     customer_address.addChild(new libxml.Element(doc,'UnitNumber', '202').attr({"xsi:type":"xsd:string"}))
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
     item_modifiers = new libxml.Element(doc,'ItemModifiers')
     # innner modifier loop here
     item_modifier = new libxml.Element(doc,'ItemModifier').attr({code:'p'})
     item_modifier.addChild(new libxml.Element(doc,'ItemModifierName').attr('xsi:nil':"true"))
     item_modifier.addChild(new libxml.Element(doc,'ItemModifierQuantity', '1'))
     item_modifier.addChild(new libxml.Element(doc,'ItemModifierPart', 'w'))
     item_modifiers.addChild(item_modifier)
     order_item.addChild(item_modifiers)
     order_items.addChild(order_item)
     
     order.addChild(order_items)
     # end items
     #payment
     payment = new libxml.Element(doc,'Payment')
     cash_payment = new libxml.Element(doc,'CashPayment')
     cash_payment.addChild(new libxml.Element(doc,'PaymentAmmount', '10000'))
     payment.addChild(cash_payment)
     order.addChild(payment)
     #end payment
     
     body = new libxml.Element(doc,'env:Body')
     action = new libxml.Element(doc, "ns1:#{action}").attr({ 'xmlns:ns1':"http://www.dominos.com/message/", encodingStyle:"http://schemas.xmlsoap.org/soap/encoding/"})
     action.addChild(order)
     body.addChild(action)
     envelope.addChild(header)
     envelope.addChild(body) 
     doc.root(envelope)
     doc.toString().replace(/\"/g, '\"')
    
log = (text) ->
  console.log text
  
  
PulseBridge.price(log, log)
console.log PulseBridge.cart


module.exports = PulseBridge
