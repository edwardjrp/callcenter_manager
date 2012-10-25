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

end
