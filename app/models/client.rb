# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  first_name        :string(255)
#  last_name         :string(255)
#  email             :string(255)
#  idnumber          :string(255)
#  target_address_id :integer
#  target_phone_id   :integer
#  phones_count      :integer
#  addresses_count   :integer
#  active            :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Client < ActiveRecord::Base
  validates :first_name, presence:  true
  validates :last_name, presence:  true
  validates :idnumber, uniqueness:  true, allow_nil: true
  validates :email, uniqueness:  true, allow_nil: true
  has_many :phones, :inverse_of => :client
  has_many :addresses, :inverse_of => :client
  has_many :carts
  accepts_nested_attributes_for :phones
  accepts_nested_attributes_for :addresses
  attr_accessible :active, :email, :first_name, :idnumber, :last_name, :phones_attributes, :addresses_attributes
  
  def self.find_clients(client)
    clients = self.scoped
    # clients = clients.merge(self.joins(:phones).where('phones.number like ?', "#{client[:phone]}%")) if client.present? && client[:phone].present?
    # clients = [] if clients.count == self.count
    return clients
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"  
  end
  
  def last_address
    Address.find_by_id self.target_address_id
  end
  
end
