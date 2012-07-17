pg = require('pg')


class Config
  
  @setup: ()->
    @connection = new pg.Client(Config.connection_string)
    @connection.connect()
  
  @getConnection: ->
    @connection
  
  @host: "localhost"
  
  @username: "radhamesbrito"
  
  @password: "siriguillo"
  
  @db: "kapiqua_development"
    
  @connection_string: "postgres://#{@username}:#{@password}@#{@host}/#{@db}"
  

module.exports = Config
