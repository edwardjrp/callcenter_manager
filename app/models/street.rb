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
  has_many :addresses
  validates :name, :presence=> true, uniqueness: { scope: :area_id}
  attr_accessible :area_id, :name
  
  
  def self.find_street(params)
    streets = self.scoped
    streets = streets.merge(self.where('lower(name) like ?', "#{params[:q].downcase}%")) if params[:q].present?
    streets = streets.merge(self.where(:area_id=> params[:area_id])) if params[:area_id].present?
    return streets
  end
end