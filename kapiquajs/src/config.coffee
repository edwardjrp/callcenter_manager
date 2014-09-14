class Config
    
  @host: "192.168.33.1"
  #@host: "10.0.0.198"
    
  @username: ()->
    switch process.env.NODE_ENV
      when 'production' then "proteus"
      when 'development' then 'proteus'
      when 'test' then 'proteus'
      else 'proteus'
    
  @password: ()->
    switch process.env.NODE_ENV
      when 'production' then "u5bl4ck"
      when 'development' then 'u5bl4ck'
      when 'test' then 'u5bl4ck'
      else 'u5bl4ck'
      
    
  @db: () ->
    switch process.env.NODE_ENV
      when 'production' then "kapiqua_#{process.env.NODE_ENV}"
      when 'development' then "kapiqua_#{process.env.NODE_ENV}"
      when 'test' then "kapiqua_#{process.env.NODE_ENV}"
      else "kapiqua_development"
      
  @connection_string: "postgres://#{@username()}:#{@password()}@#{@host}/#{@db()}"

    

module.exports = Config
