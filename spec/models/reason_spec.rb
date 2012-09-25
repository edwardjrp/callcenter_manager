require 'spec_helper'

describe Reason do
  describe 'Validations' do
    before{create :reason}
    
    it { should have_many :carts }
    it { should validate_presence_of :description }
    it { should validate_uniqueness_of :description }
  end
end
