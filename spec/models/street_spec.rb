# == Schema Information
#
# Table name: streets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :integer
#

require 'spec_helper'

describe Street do

  describe "Validations" do

    before { create :street }
    
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to(:area_id) }
    it { should belong_to :area }
    it { should have_many :addresses }
    
  end

  describe '#merge' do
    let!(:street1) { create :street }
    let!(:street2) { create :street }
    let!(:addresses) { create_list :address, 4, street: street1 }

    it 'should add addresses from other streets to this one' do
      street2.merge(street1)
      street2.reload.addresses.should =~ addresses
    end

    it 'should destroy the remove the original street' do
      expect{ street2.merge(street1) }.to change { Street.count }.from(2).to(1)
    end
  end
end
