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
    before(:each)do
      @phone = FactoryGirl.create :phone
    end
    it{should validate_uniqueness_of(:number).scoped_to(:ext) }
    it{should belong_to :client }
    it{should validate_presence_of :client }
  end
  

  describe "when deleting the last phone" do
    before(:each) do
      @phone = FactoryGirl.create :phone
    end

    it "should add errors to the phone" do
      @phone.destroy
      @phone.errors.should_not be_empty
      Phone.count.should_not be_zero
    end

    it "should not delete the last phone" do
      expect{@phone.destroy}.to_not change{Phone.count}.from(1).to(0)
    end
  end

  it "should clear phone number" do 
    @phone = Phone.new do |phone|
      phone.number = '(809)-555 1234'
      phone.client_id = 1
    end
    @phone.valid?
    @phone.number.should == "8095551234"
  end
  
end
