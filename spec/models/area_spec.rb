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
  
end
