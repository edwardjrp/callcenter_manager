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
  validates :client_id, presence: true
  belongs_to :client, :counter_cache => true
  attr_accessible :ext, :number
  before_validation :clear_number
  
  private
    def clear_number
      self.number = self.number.gsub(/[^\d]/,'') if self.number.present?
    end
end
