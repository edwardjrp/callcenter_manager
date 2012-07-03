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

class Area < ActiveRecord::Base
  belongs_to :city
  belongs_to :store
  has_many :streets
  validates :name, :presence => true, :uniqueness => true
  attr_accessible :city_id, :name
end
