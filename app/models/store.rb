# == Schema Information
#
# Table name: stores
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  ip         :string(255)
#  city_id    :integer
#  storeid    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Store < ActiveRecord::Base
  has_many :carts
  belongs_to :city
  validates :name, :presence =>true, :uniqueness => true
  validates :address, :presence =>true, :uniqueness => true
  validates :ip, :presence =>true, :uniqueness => true  
  validates :storeid, :presence =>true, :uniqueness => true
  attr_accessible :address, :city_id, :ip, :name, :storeid
end
