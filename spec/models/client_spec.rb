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

    before { create :client,  first_name: 'test' }
    
    
    it { should validate_presence_of :first_name}
    it { should validate_presence_of :last_name}  
    it { should validate_uniqueness_of :idnumber}
    it { should ensure_length_of(:idnumber).is_equal_to(11) }
    it { should validate_uniqueness_of :email }  
    it { should validate_format_of(:email).with('test@mail.com') }
    it { should have_many :phones }
    it { should have_many :tax_numbers }


  end
  
  describe "instance methods" do
    let!(:client) { create :client }
    
    
    it " full_name: should return the concatenation of first_name and last_name" do
      client.full_name.should == "#{client.first_name} #{client.last_name}"  
    end

  end

  describe '#set_last_phone' do
    let!(:client) { create :client }
    let!(:phone1) { create :phone, client: client }
    let!(:phone2) { create :phone, client: client }

    it "should set the last_phone for the client" do
      client.last_phone.should == phone1
      client.set_last_phone(phone2)
      client.last_phone.should == phone2
    end
    
  end

  describe '#set_last_address' do
    let!(:client) { create :client }
    let!(:address1) { create :address, client: client }
    let!(:address2) { create :address, client: client }

    it "should set the last_phone for the client" do
      client.last_address.should == address1
      client.set_last_address(address2)
      client.last_address.should == address2
    end
    
  end

  # describe '#last_store' do
  # end

  describe "when mergin clients" do
  
    let!(:client) { create :client,  first_name: 'test' }
    let!(:client_source) { create :client, first_name: 'test source' }
    let!(:phone) { create :phone, client: client_source }
    let!(:client_attr) { { 'first_name' => client_source.first_name, 'last_name' => client_source.last_name, 'email' => client_source.email, 'idnumber' => client_source.idnumber, 'phones_attributes' => { '0' => phone.attributes } } }
    

    it "should merge the 2 clients " do
      client.first_name.should == 'test'
      expect { client.merge( client_attr, client_source.id) }.to change{ Client.count }.by(-1)
      client.reload.first_name.should == 'test source'
    end

    it "should delete the source client" do
      source_id = client_source.id
      client.merge( client_attr, client_source.id)
      Client.exists?(source_id).should be_false
    end

  end

end
