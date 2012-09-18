class Config
  
  @host: "localhost"
  
  @username: "soporte"
  
  @password: "d0m1n0s"
  
  @db: "kapiqua_production"
    
  @connection_string: "postgres://#{@username}:#{@password}@#{@host}/#{@db}"
  

module.exports = Config
