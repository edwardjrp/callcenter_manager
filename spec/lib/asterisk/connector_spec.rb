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

  describe '#total_incoming' do
    it 'should return the total incoming calls for a given date range' do
      Net::HTTP.stub(:get).and_return({"resultcode"=>0, "result"=>{"totalincoming"=>16573}}.to_json)
      Asterisk::Connector.new(Date.current.yesterday.to_time, Time.now).total_incoming.should == 16573
    end
  end

  describe '#calls_by_hour' do
    let!(:calls_by_hour_hash) do
      {
        "resultcode"=>0,
        "result"=>{
          "2013-03-06"=>{
            "0"=>"1",
            "1"=>"2",
            "7"=>"2",
            "10"=>"9",
            "11"=>"34",
            "12"=>"42",
            "13"=>"33",
            "14"=>"26",
            "15"=>"22",
            "16"=>"23",
            "17"=>"41",
            "18"=>"46",
            "19"=>"72",
            "20"=>"58",
            "21"=>"49",
            "22"=>"23",
            "23"=>"3"
          },
          "2013-03-07"=>{
            "10"=>"23",
            "11"=>"35",
            "12"=>"87",
            "13"=>"72",
            "14"=>"11"
          }
        }
      }
    end

    before { Net::HTTP.stub(:get).and_return(calls_by_hour_hash.to_json) }

    it 'should return a hash of calls per day per hour' do
      Asterisk::Connector.new(Date.current.yesterday.to_time, Time.now).calls_by_hour["2013-03-07"].should == { "10"=>"23","11"=>"35","12"=>"87","13"=>"72","14"=>"11"}
    end
  end

  describe '#agents_by_hour' do
    let!(:agents_by_hour_hash) do
      {
        "resultcode"=>0,
        "result"=>{
          "2013-03-06"=>{
            "0"=>"1.0",
            "1"=>"1.0",
            "2"=>"1.0",
            "3"=>"1.0",
            "4"=>"1.0",
            "5"=>"1.0", 
            "6"=>"1.0",
            "7"=>"1.0",
            "8"=>"1.0",
            "10"=>"2.0",
            "11"=>"3.75",
            "12"=>"4.75",
            "13"=>"5.0",
            "14"=>"4.75",
            "15"=>"5.0",
            "16"=>"2.75",
            "17"=>"6.0",
            "18"=>"8.75",
            "19"=>"9.5",
            "20"=>"10.0",
            "21"=>"10.0",
            "22"=>"3.5",
            "23"=>"1.0"
          },
          "2013-03-07"=>{
            "10"=>"4.3333",
            "11"=>"6.5",
            "12"=>"8.75",
            "13"=>"9.0",
            "14"=>"9.0"
          }
        }
      }
    end

    before { Net::HTTP.stub(:get).and_return(agents_by_hour_hash.to_json) }

    it 'should return a hash connected agents per day per hour' do
      Asterisk::Connector.new(Date.current.yesterday.to_time, Time.now).agents_by_hour["2013-03-07"].should == {"10"=>"4.3333","11"=>"6.5","12"=>"8.75","13"=>"9.0","14"=>"9.0"}
    end
  end
end