# == Schema Information
#
# Table name: streets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Street do
  describe "Validations" do
    before(:each) do
      FactoryGirl.create :street
    end
    it{should validate_presence_of :name}
    it{should validate_uniqueness_of(:name).scoped_to(:area_id)}
    it{should belong_to :area}
  end
end
