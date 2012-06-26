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
#  active            :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe Client do
  describe 'Validations' do
    before(:each) do
      @client = FactoryGirl.create :client
    end
    
    it{should validate_presence_of :first_name}
    it{should validate_presence_of :last_name}  
    it{should validate_uniqueness_of :idnumber}
    it{should validate_uniqueness_of :email}  
    it{should have_many :phones}
  end
end
