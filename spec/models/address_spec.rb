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
    before(:each)do
      FactoryGirl.create :address
    end
    it{should belong_to :client}
    it{should belong_to :street}
    it{should validate_presence_of :street_id}
    it{should validate_presence_of :client_id}
  end
end
