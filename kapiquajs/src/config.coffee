class Config
    
  @host: "localhost"
    
  @username: ()->
    switch process.env.NODE_ENV
      when 'production' then "proteus"
      when 'development' then 'radhamesbrito'
      when 'test' then 'radhamesbrito'
      else 'radhamesbrito'
    
  @password: ()->
    switch process.env.NODE_ENV
      when 'production' then "u5bl4ck"
      when 'development' then 'siriguillo'
      when 'test' then 'siriguillo'
      else 'siriguillo'
      
    
  @db: () ->
    switch process.env.NODE_ENV
      when 'production' then "kapiqua_#{process.env.NODE_ENV}"
      when 'development' then "kapiqua_#{process.env.NODE_ENV}"
      when 'test' then "kapiqua_#{process.env.NODE_ENV}"
      else "kapiqua_development"
      
  @connection_string: "postgres://#{@username()}:#{@password()}@#{@host}/#{@db()}"

    

module.exports = Config
