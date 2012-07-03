# == Schema Information
#
# Table name: stores
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  ip         :string(255)
#  city_id    :integer
#  storeid    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Store do
  describe "Validations" do
    before(:each) do
      FactoryGirl.create :store
    end
    it{should validate_presence_of :name}
    it{should validate_uniqueness_of :name}
    it{should validate_presence_of :address}
    it{should validate_presence_of :ip}
    it{should validate_uniqueness_of :ip}
    it{should validate_presence_of :storeid}
    it{should validate_uniqueness_of :storeid}
    it{should belong_to :city}
    it{should have_many :carts}
  end
end
