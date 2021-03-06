# == Schema Information
#
# Table name: phones
#
#  id         :integer          not null, primary key
#  number     :string(255)
#  ext        :string(255)
#  client_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Phone do
  describe "validation" do
    before { create :phone }
    
    it { should validate_uniqueness_of(:number).scoped_to(:ext) }
    it { should belong_to :client }
    it { should validate_presence_of :client }

  end
  

  describe "when deleting the last phone" do
    
    let!(:phone) { FactoryGirl.create :phone }

    it "should add errors to the phone" do
      phone.destroy
      phone.errors.should_not be_empty
      Phone.count.should_not be_zero
    end

    it "should not delete the last phone" do
      expect { phone.destroy }.to_not change{Phone.count}.from(1).to(0)
    end

  end

  describe '#client_target?' do
    let!(:client) { create(:client, first_name: 'tester') }
    let!(:phone1) { create :phone, client: client, number: '8095551234', ext: '99' }
    let!(:phone2) { create :phone, client: client, number: '8095551224', ext: '99' }
    before { client.set_last_phone(phone1) }

    it 'should return true if its the client is target phone' do
      phone1.should be_client_target
    end

    it 'should return false if its not the client is target phone' do
      phone2.should_not be_client_target
    end

  end

  it "should clear phone number" do 

    phone = Phone.new do |phone|
      phone.number = '(809)-555 1234'
      phone.client_id = 1
    end
    phone.valid?
    phone.number.should == "8095551234"
    
  end
  
end
