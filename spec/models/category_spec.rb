# == Schema Information
#
# Table name: categories
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  has_options  :boolean          default(FALSE)
#  type_unit    :boolean          default(FALSE)
#  multi        :boolean          default(FALSE)
#  hidden       :boolean          default(FALSE)
#  base_product :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Category do
  describe "Validation" do
    before(:each)do
      FactoryGirl.create :category
    end
    it{should validate_presence_of :name}
    it{should validate_uniqueness_of :name}
    it{should have_many :products}
  end
end
