_ = require('underscore')
request = require('request')


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
  
    
# PulseBridge.send('TestConnection','<Value>Hello there</Value>', null, (res_data) -> console.log res_data )


module.exports = PulseBridge
