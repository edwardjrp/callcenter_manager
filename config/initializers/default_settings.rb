case Rails.env
  when 'production'
    Kapiqua.defaults[:node_url] = 'contactcerter.local:3030'
  else
    Kapiqua.defaults[:node_url] = 'localhost:3030'
end

#Kapiqua.defaults[:price_store_ip] = "192.168.85.60"
#Kapiqua.defaults[:price_store_id] = "99998"
Kapiqua.defaults[:price_store_ip] = '10.0.0.166'
Kapiqua.defaults[:price_store_id] = '15871'
Kapiqua.defaults[:pulse_port] = '59101'
Kapiqua.defaults[:document_location] = 'RemotePulseAPI/RemotePulseAPI.WSDL'
Kapiqua.defaults[:olo_url] = '172.16.85.2:8808'