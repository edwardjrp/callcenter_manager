# == Schema Information
#
# Table name: reasons
#
#  id          :integer          not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Reason < ActiveRecord::Base
  has_many :carts
  validates :description, presence: true, uniqueness: true
  attr_accessible :description
end
