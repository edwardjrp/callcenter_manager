# == Schema Information
#
# Table name: addresses
#
#  id                    :integer          not null, primary key
#  client_id             :integer
#  street_id             :integer
#  number                :string(255)
#  unit_type             :string(255)
#  unit_number           :string(255)
#  postal_code           :string(255)
#  delivery_instructions :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Address < ActiveRecord::Base
  belongs_to :client, :counter_cache => true
  belongs_to :street
  delegate :area, :to => :street, :prefix => true
  validates :street_id, presence: true
  validates :number, presence: true
  attr_accessible :client_id, :delivery_instructions, :number, :postal_code, :street_id, :unit_number, :unit_type
  
  
  def client_target?
    return false if client.nil?
    return false if client.target_address_id.nil?
    client.target_address_id == self.id
  end


  def store
    return nil if street.nil?
    return nil if street.store.nil?
    street.store
  end

  def self.find_address(query)
    return nil if query.blank?
    areas = Area.where("areas.name ILIKE ?", "%#{query['area']}%")
    areas = areas.merge(Area.where(city_id: City.find(query['city_id']))) if query['city_id'] and City.exists? query['city_id']
    if areas.count.nonzero?
      areas_ids = areas.map(&:id)
      streets = Street.where("name ILIKE ?", "%#{query['street']}%").where(area_id: areas_ids) if query['street'].present?
    else
      streets = Street.where("name ILIKE ?", "%#{query['street']}%") if query['street'].present?
    end
    streets
  end
end
