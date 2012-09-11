case Rails.env
  when 'production'
    Kapiqua.defaults[:node_url] = "contactcerter.local:3030"
  else
    Kapiqua.defaults[:node_url] = "localhost:3030"
end

Kapiqua.defaults[:price_store_ip] = "192.168.85.60"
Kapiqua.defaults[:price_store_id] = "99998"
Kapiqua.defaults[:pulse_port] = "59101"
Kapiqua.defaults[:document_location] = 'RemotePulseAPI/RemotePulseAPI.WSDL'