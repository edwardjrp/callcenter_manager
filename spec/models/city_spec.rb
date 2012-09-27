# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe City do

  describe "Validations" do

    before { create :city }
    
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should have_many :stores }
    it { should have_many :areas }    

  end

end
