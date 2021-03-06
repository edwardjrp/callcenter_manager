# == Schema Information
#
# Table name: addresses
#
#  id                    :integer          not null, primary key
#  client_id             :integer
#  street_id             :integer
#  number                :string(255)
#  unit_type             :string(255)
#  unit_number           :string(255)
#  postal_code           :string(255)
#  delivery_instructions :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe Address do

  describe "Validation" do

    before { create :address }

    it{should belong_to :client}
    it{should belong_to :street}
    it{should validate_presence_of :number}
    it{should validate_presence_of :street_id}

  end

  describe '#client_target?' do
    let!(:client) { create(:client, first_name: 'tester') }
    let!(:address1) { create :address, client: client}
    let!(:address2) { create :address, client: client}
    before { client.set_last_address(address1) }

    it 'should return true if its the client is target address' do
      address1.should be_client_target
    end

    it 'should return false if its not the client is target address' do
      address2.should_not be_client_target
    end

  end

  describe '#store' do 
    let!(:store) { create :store }
    let!(:street) { create :street , store: store}
    let!(:address_with_area_and_store) { create :address, street: street }

    it 'should return the store if is assigned to the current address' do
      address_with_area_and_store.store.should == store
    end
  end
  
end
