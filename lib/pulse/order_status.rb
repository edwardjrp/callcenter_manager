require 'rubygems'
require 'savon'

module Pulse
  class OrderStatus

    attr_reader :store, :order_id

    def initialize(store, order_id)
      @store = store
      @order_id = order_id
      @client = Savon::Client.new
      wsdl_url = "http://#{store.ip}:59101/RemotePulseAPI/RemotePulseAPI.WSDL"
      @client.wsdl.document = wsdl_url
      @client.wsdl.endpoint = wsdl_url
    end

    def get
      response = @client.request :ns1, :get_order_status, "xmlns:ns1" => "http://www.dominos.com/message/", "encodingStyle" => "http://schemas.xmlsoap.org/soap/encoding/"  do |soap|
        soap.header = {
          "Authorization" => {
            "FromURI" => "dominos.com",
            "User" => "TestingAndSupport",
            "Password" => "supp0rtivemeasures",
            "TimeStamp" => ""
          }
        }
        soap.body = {
          "StoreID" => store.id, "StoreOrderID" => order_id
        }
        Nokogiri::XML(soap.to_xml).css('OrderProgress').inner_text
      end
    end
  end
end