module Asterisk
  class Connector
    HOST = 'http://192.168.85.80'
    PORT = '8080'
    USERNAME = 'cdruser'
    PASSWORD = 'cdrus3rd1s8x10bctb3st'

    def initialize(start_time = Time.zone.now.beginning_of_day, end_time = Time.zone.now)
      @start_time = start_time
      @end_time = end_time
    end

    def total_incoming
      result = JSON.parse(Net::HTTP.get(URI.parse("#{end_point}/totalincoming.json?fecha1=#{@start_time.to_date}&fecha2=#{@end_time.to_date}&token=#{token(nonce)}&nonce=#{nonce}")))
      Rails.logger.info result.inspect
      result["result"]["totalincoming"] if result and result["result"]
    end

    def calls_by_hour
      result = JSON.parse(Net::HTTP.get(URI.parse("#{end_point}/callsbyhour.json?fecha1=#{@start_time.to_date}&fecha2=#{@end_time.to_date}&token=#{token(nonce)}&nonce=#{nonce}")))
      Rails.logger.info result.inspect
      result["result"] if result and result["result"]
    end

    def agents_by_hour
      result = JSON.parse(Net::HTTP.get(URI.parse("#{end_point}/agentsbyhour.json?fecha1=#{@start_time.to_date}&fecha2=#{@end_time.to_date}&token=#{token(nonce)}&nonce=#{nonce}")))
      Rails.logger.info result.inspect
      result["result"] if result and result["result"]
    end

    private 

    def nonce
      @nonce ||= SecureRandom.hex(10)
    end

    def end_point
      "#{HOST}:#{PORT}"
    end

    def token(nonce_key)
      Digest::MD5.hexdigest("#{USERNAME}:#{nonce_key}:#{Digest::MD5.hexdigest(PASSWORD)}")
    end
  end
end