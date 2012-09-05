# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class City < ActiveRecord::Base
  has_many :stores
  has_many :areas, dependent: :destroy
  validates :name, :presence => true, :uniqueness=> true
  attr_accessible :name
end
