# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city_id    :integer
#  store_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Area do

  describe "Validation" do

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to(:city_id) }
    it { should belong_to :city }
    it { should belong_to :store }
    it { should have_many :streets }

  end

  describe 'finder' do
    let!(:city1) { create :city }
    let!(:city2) { create :city }
    let!(:area1) { create :area, city: city1 , name: 'test_area_1' }
    let!(:area2) { create :area, city: city1 , name: 'test_area_2' }
    let!(:area3) { create :area, city: city2 , name: 'test_area_1' }

    describe '.find_area' do
      it 'should return the area containning the giveng name in the current city scope' do
        Area.find_area({q: 'test_area_1', city_id: city1.id }).should include(area1)
        Area.find_area({q: 'test_area_1', city_id: city1.id }).should_not include(area2)
        Area.find_area({q: 'test_area_1', city_id: city1.id }).should_not include(area3)
      end
    end

  end
  
end
