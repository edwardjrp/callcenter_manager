case Rails.env
  when 'production'
    Kapiqua.defaults[:node_url] = "contactcerter.local:3030"
  else
    Kapiqua.defaults[:node_url] = "localhost:3030"
end