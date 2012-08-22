# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  first_name        :string(255)
#  last_name         :string(255)
#  email             :string(255)
#  idnumber          :string(255)
#  target_address_id :integer
#  target_phone_id   :integer
#  phones_count      :integer
#  addresses_count   :integer
#  active            :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  imported          :boolean          default(FALSE)
#

require 'spec_helper'

describe Client do
  describe 'Validations' do
    before(:each) do
      @client = FactoryGirl.create :client,  first_name: 'test'
    end
    
    it{should validate_presence_of :first_name}
    it{should validate_presence_of :last_name}  
    it{should validate_uniqueness_of :idnumber}
    it{should validate_uniqueness_of :email}  
    it{ should validate_format_of(:email).with('test@mail.com')}

    it{should have_many :phones}
  end
  
  describe "instance methods" do
    before(:each) do
      @client = FactoryGirl.create :client
    end
    
    it " full_name: should return the concatenation of first_name and last_name" do
      @client.full_name.should == "#{@client.first_name} #{@client.last_name}"  
    end
  end

  describe "when mergin clients" do
    before(:each) do
      @client = FactoryGirl.create :client,  first_name: 'test'
      @client_source = FactoryGirl.create :client, first_name: 'test source'
      @phone = FactoryGirl.create :phone, client: @client_source
      @client_attr = {"first_name"=>@client_source.first_name,"last_name"=>@client_source.last_name,"email"=>@client_source.email,"idnumber"=>@client_source.idnumber, 'phones_attributes' => { '0'=> @phone.attributes}}
    end

    it "should merge the 2 clients " do
        @client.first_name.should == 'test'
        expect{@client.merge(@client_attr, @client_source.id)}.to change{Client.count}.by(-1)
        @client.first_name.should == 'test source'
    end

    it "should delete the source client" do
      source_id = @client_source.id
      @client.merge(@client_attr, @client_source.id)
      Client.exists?(source_id).should be_false
    end
  end
end
