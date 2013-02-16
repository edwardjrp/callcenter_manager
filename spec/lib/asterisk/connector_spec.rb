require 'spec_helper'

describe Asterisk::Connector do
  it 'should return the host' do
    Asterisk::Connector::HOST.should == 'http://192.168.85.80'
  end

  it 'should return the port' do
    Asterisk::Connector::PORT.should == '8080'
  end

  it 'should return the username' do
    Asterisk::Connector::USERNAME.should == 'cdruser'
  end

  it 'should return the password' do
    Asterisk::Connector::PASSWORD.should == 'cdrus3rd1s8x10bctb3st'
  end

  it 'should return the end point' do
    Asterisk::Connector.new.end_point.should == "#{Asterisk::Connector::HOST}:#{Asterisk::Connector::PORT}"
  end

  it 'should return the connection token' do
    nonce_key = SecureRandom.hex(10)
    token_result = Digest::MD5.hexdigest("#{Asterisk::Connector::USERNAME}:#{nonce_key}:#{Digest::MD5.hexdigest(Asterisk::Connector::PASSWORD)}")
    Asterisk::Connector.new.token(nonce_key).should == token_result
  end

  it 'should return the connection token' do
    Net::HTTP.stub(:get).and_return({"resultcode"=>0, "result"=>{"totalincoming"=>16573}}.to_json)
    Asterisk::Connector.new(Date.current.yesterday.to_time, Time.now).total_incoming.should == 16573
  end


end