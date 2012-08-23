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
  belongs_to :client, :counter_cache => true#,:inverse_of => :addresses
  belongs_to :street
  delegate :area, :to => :street, :prefix => true
  # validates :client_id, presence: true
  validates :street_id, presence: true
  validates :number, presence: true
  attr_accessible :client_id, :delivery_instructions, :number, :postal_code, :street_id, :unit_number, :unit_type
  
  
  def store
    return nil if street.nil?
    return nil if street.area.nil?
    return nil if street.area.store.nil?
    street.area.store
  end
end
