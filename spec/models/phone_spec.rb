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
    it{should validate_presence_of :client_id }
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
