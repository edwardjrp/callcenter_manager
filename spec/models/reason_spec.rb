require 'spec_helper'

describe Reason do
  describe 'Validations' do
    before{create :reason}
    
    it { should have_many :carts }
    it { should validate_presence_of :content }
    it { should validate_uniqueness_of :content }
  end
end
