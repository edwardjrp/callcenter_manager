# == Schema Information
#
# Table name: tax_numbers
#
#  id         :integer          not null, primary key
#  rnc        :string(255)
#  verified   :boolean          default(FALSE)
#  client_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe TaxNumber do
  describe "Validation" do

    before {create :tax_number}

    it { should validate_presence_of :rnc }
    it { should validate_uniqueness_of(:rnc).scoped_to(:client_id) }
    it { should belong_to :client}
    it { should validate_uniqueness_of :client_id }
  end
end
