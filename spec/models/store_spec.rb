# encoding: utf-8
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
      @store = FactoryGirl.create :store
    end
    it{should validate_presence_of :name}
    it{should validate_uniqueness_of :name}
    it{should validate_presence_of :address}
    it{should validate_presence_of :ip}
    it{should validate_uniqueness_of :ip}
    it{should validate_presence_of :storeid}
    it{should validate_uniqueness_of :storeid}
    it{should validate_format_of(:ip).with('255.255.255.255')}
    it{should validate_format_of(:ip).not_with('256.255.255.255').with_message(/lid/)}
    it{should validate_format_of(:ip).not_with('256.255.255. 255').with_message(/lid/)}
    it{should validate_format_of(:ip).not_with('256.255.255255').with_message(/lid/)}
    it{should belong_to :city}
    it{should have_many :carts}
    it{should have_many :store_products}
  end
end
