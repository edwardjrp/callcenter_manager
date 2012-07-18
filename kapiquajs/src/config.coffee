pg = require('pg')


class Config
  
  @host: "localhost"
  
  @username: "radhamesbrito"
  
  @password: "siriguillo"
  
  @db: "kapiqua_development"
    
  @connection_string: "postgres://#{@username}:#{@password}@#{@host}/#{@db}"
  

module.exports = Config
