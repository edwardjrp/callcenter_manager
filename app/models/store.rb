# == Schema Information
#
# Table name: stores
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  address      :string(255)
#  ip           :string(255)
#  city_id      :integer
#  storeid      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  discontinued :boolean          default(FALSE)
#

class Store < ActiveRecord::Base
  has_many :carts
  belongs_to :city
  has_many :store_products
  has_many :streets
  has_many :products, :through=> :store_products
  validates :name, :presence =>true, :uniqueness => true
  validates :address, :presence =>true, :uniqueness => true
  validates :ip, :presence =>true, :uniqueness => true  
  validates :storeid, :presence =>true, :uniqueness => true
  validates :ip , :format => {:with=>/^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/}
  attr_accessible :name, :address, :city_id, :ip, :storeid
end
