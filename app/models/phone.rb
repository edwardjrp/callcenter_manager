# == Schema Information
#
# Table name: phones
#
#  id         :integer          not null, primary key
#  number     :string(255)
#  ext        :string(255)
#  client_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Phone < ActiveRecord::Base
  validates :number, uniqueness: { scope: :ext}
  belongs_to :client, :counter_cache => true,:inverse_of => :phones
  validates :client, presence: true
  attr_accessible :ext, :number
  before_validation :clear_number
  before_destroy :ensure_one_phone
  
  def self.find_phones(client)
    phones = self.scoped
    phones = phones.merge(self.where('number like ?', "#{client[:phone].gsub(/[-. ]/,'')}%")) if client.present? && client[:phone].present?
    phones = phones.merge(self.where('ext like ?', "#{client[:ext]}%")) if client.present? && !client[:ext].blank?
    return phones.limit(10).order(:id)
  end
  
  
  private
    def clear_number
      self.number = self.number.gsub(/[^\d]/,'') if self.number.present?
    end

    def ensure_one_phone
      if self.client.present?
        client = self.client
        unless client.phones.count > 1
          self.errors.add(:base, 'El cliente debe tener al menos un numero telefonico')
          return false
        end
      end
    end
end
