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
#  active            :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  imported          :boolean          default(FALSE)
#

class Client < ActiveRecord::Base
  validates :first_name, presence:  true
  validates :last_name, presence:  true
  validates :idnumber, uniqueness:  true, allow_nil: true, :length => { :is => 11 }, :allow_blank => false
  validates :email, uniqueness:  true, :email_format => true, allow_nil: true, :allow_blank => false
  has_many :phones, :inverse_of => :client, dependent: :destroy
  has_many :addresses, dependent: :destroy#, :inverse_of => :client
  has_many :carts
  has_many :tax_numbers, dependent: :destroy
  before_validation :fix_blanks
  before_destroy :ensure_no_carts
  accepts_nested_attributes_for :phones
  accepts_nested_attributes_for :tax_numbers, :reject_if => proc { |tax_number| tax_number['rnc'].blank? }
  accepts_nested_attributes_for :addresses, :reject_if => proc { |address| address['street_id'].blank? || address['number'].blank? }
  attr_accessible :active, :email, :first_name, :idnumber, :last_name, :phones_attributes, :addresses_attributes, :tax_numbers_attributes
  self.per_page = 15

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
    Address.find_by_id(self.target_address_id) || self.addresses.order(:id).first if self.addresses.any?
  end

  def last_phone
    Phone.find_by_id(self.target_phone_id) || self.phones.order(:id).first if self.phones.any?
  end

  def set_last_phone(phone)
    if self.phones.include? phone
      self.target_phone_id = phone.id
      self.save
    end
  end

  def set_last_address(address)
    if self.addresses.include? address
      self.target_address_id = address.id
      self.save
    end
  end

  def mark_as_imported
    self.imported = true
    self.save
  end

  def merge(attr, source_id)
    self.transaction do
      self.first_name = attr['first_name']
      self.last_name = attr['last_name']
      self.email = attr['email']
      self.idnumber = attr['idnumber']
      if attr['phones_attributes'].present? && attr['phones_attributes'].any?
        attr['phones_attributes'].each_value do |phone_attr|
          if Phone.exists?(phone_attr['id'])
            phone = Phone.find_by_id(phone_attr['id'])
            phone.client_id = self.id 
            phone.save
          end
        end
      end
      if attr['addresses_attributes'].present? && attr['addresses_attributes'].any?
        attr['addresses_attributes'].each_value do |address_attr|
          if Address.exists?(address_attr['id'])
            address = Address.find_by_id(address_attr['id'])
            address.client_id = self.id 
            address.save
          end
        end
      end
      self.class.find_by_id(source_id).destroy if self.class.exists?(source_id)
      self.save
    end
  end

  def cedula
    new_idnumber= idnumber.to_s.strip unless idnumber.nil?
    begin
      if new_idnumber.length == 11
        return new_idnumber.gsub(/([0-9]{3})([0-9]{7})([0-9]{1})/,"\\1-\\2-\\3")
     elsif new_idnumber.length == 9
        return new_idnumber.gsub(/([0-9]{1})([0-9]{2})([0-9]{5})([0-9]{1})/,"\\1-\\2-\\3-\\4")
     else
       return new_idnumber
     end
    rescue
      return new_idnumber
    end
  end

  private
    def ensure_no_carts
      if self.carts.completed.count.nonzero?
        self.errors.add(:base, 'Algunas ordenes hacen referencia a este cliente') 
        false
      end
    end

    def fix_blanks
      self.idnumber = nil if self.idnumber == ''
      self.email = nil if self.email == ''
    end

end
