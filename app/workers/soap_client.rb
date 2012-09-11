# Base class that connects to the pulse api
# @todo missing relation to the stores model
# @todo should load configuration from a YAML file
class SoapClient
  require "savon"
  
  def initialize(store_ip, store_port, document_location)
    @store_ip = store_ip
    @store_port = store_port
    @document_location = document_location
    Savon.configure do |config|
      config.soap_version = 1
      config.log = true            # disable logging
      config.log_level = :debug      # changing the log level
      config.logger = Logger.new(Rails.root.join("log/pulse_comm_#{Rails.env}.log"),'daily')
    end
  end
  attr_reader :store_ip, :store_port, :document_location
  
  def self.remote_url(client)
    "http://#{client.store_ip}:#{client.store_port}/#{client.document_location}"
  end
  
  
  def get(data ,soap_action)
    client = Savon::Client.new
    client.wsdl.document = self.class.remote_url(self)
    client.wsdl.endpoint = self.class.remote_url(self)
    
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
    return "#{response.to_xml}".force_encoding('UTF-8')      
  end
  
      
   
    
    
end
