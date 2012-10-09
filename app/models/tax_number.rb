# == Schema Information
#
# Table name: tax_numbers
#
#  id         :integer          not null, primary key
#  rnc        :string(255)
#  verified   :boolean          default(FALSE)
#  client_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TaxNumber < ActiveRecord::Base
  validates :rnc, presence: true, uniqueness: { scope: :client_id }, length: {  minimum: 9, maximum: 11 }
  validates :client_id, presence: true
  belongs_to :client
  attr_accessible :rnc, :client_id, :verified


  def verify
    TaxpayerIdentification.find_by_idnumber(self.rnc).tap do |tax_id|
      self.verified = tax_id.present?
      self.save
    end
  end
end
