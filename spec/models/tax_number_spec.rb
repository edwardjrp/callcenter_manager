# == Schema Information
#
# Table name: tax_numbers
#
#  id          :integer          not null, primary key
#  rnc         :string(255)
#  fiscal_type :string(255)
#  verified    :boolean          default(FALSE)
#  client_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe TaxNumber do
  describe "Validation" do

    before { create :tax_number }

    it { should validate_presence_of :rnc }
    it { should ensure_length_of(:rnc).is_at_least(9).is_at_most(11) }
    it { should validate_uniqueness_of(:rnc).scoped_to(:client_id) }
    it { should belong_to :client}
    it { should ensure_inclusion_of(:fiscal_type).in_array(["FinalConsumer","3rdParty","SpecialRegme","Government"])}
    # it { should validate_presence_of :client_id }
  end

  describe 'Verify' do
    let!(:tax_number) { create :tax_number, rnc: '11013456354' }
    let!(:tax_number_fail) { create :tax_number, rnc: '11015456399' }
    let!(:tax_id) { create :taxpayer_identification, idnumber: '11013456354' }

    it 'should be true if the rnc is found' do
      tax_number.should_not be_verified
      tax_number.verify
      tax_number.should be_verified
    end

    it 'should be false if the rnc is not found' do
      tax_number_fail.should_not be_verified
      tax_number_fail.verify
      tax_number_fail.should_not be_verified
    end
  end
end
