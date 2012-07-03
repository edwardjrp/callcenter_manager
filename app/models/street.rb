# == Schema Information
#
# Table name: streets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Street < ActiveRecord::Base
  belongs_to :area
  validates :name, :presence=> true, uniqueness: { scope: :area_id}
  attr_accessible :area_id, :name
end
