require 'savon'

price_store_ip = "10.0.0.166"
price_store_id = "15871"
pulse_port = "59101"
document_location = 'RemotePulseAPI/RemotePulseAPI.WSDL'
olo_url = '172.16.85.2:8808'
soap_action = "get_store_products"

remote_url = "http://#{price_store_ip}:#{pulse_port}/#{document_location}"


Savon.configure do |config|
  config.soap_version = 1
  #config.log = true            # disable logging
  #config.log_level = :debug      # changing the log level
  #config.logger = Logger.new(Rails.root.join("log/pulse_comm_#{Rails.env}.log"),'daily')
end

client = Savon::Client.new
#client.wsdl = remote_url
client.wsdl.document = remote_url
client.wsdl.endpoint = remote_url


data =  {"StoreID" => price_store_id}

response = client.request :ns1, soap_action, "xmlns:ns1" => "http://www.dominos.com/message/", "encodingStyle" => "http://schemas.xmlsoap.org/soap/encoding/"  do |soap|
  soap.header = {
    "Authorization" => {
      "FromURI" => 'dominos.com',
      "User" => 'TestingAndSupport',
      "Password" => 'supp0rtivemeasures',
      "TimeStamp" => ''
    }
  }

  soap.body = data
  soap.xml = soap.to_xml.gsub(/<\/ItemModifier [^>]+>/, "</ItemModifier>")

end

response.inspect



