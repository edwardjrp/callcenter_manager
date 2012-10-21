# encoding: utf-8
# == Schema Information
#
# Table name: tax_numbers
#
#  id           :integer          not null, primary key
#  rnc          :string(255)
#  fiscal_type  :string(255)
#  verified     :boolean          default(FALSE)
#  client_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_name :string(255)
#

class TaxNumber < ActiveRecord::Base
  validates :rnc, presence: true, uniqueness: { scope: :client_id }, length: {  minimum: 9, maximum: 11 }
  validates :client_id, presence: true, on: :update
  validates :fiscal_type, inclusion: { in: ["FinalConsumer","3rdParty","SpecialRegme","Government"] }
  belongs_to :client
  attr_accessible :rnc, :client_id, :verified, :fiscal_type, :company_name

  scope :with_verification, where(verified: true)

  def self.fiscal_types
    ["Consumidor Final","Crédito Fiscal","Regímenes Especiales","Gubernamental"]
  end
  
  def self.pulse_fiscal_types
    ["FinalConsumer","3rdParty","SpecialRegme","Government"]
  end

  def self.valid_fiscal_types
    pulse_fiscal_types.zip(fiscal_types)
  end

  def tipo_fiscal
    self.class.fiscal_types[self.class.pulse_fiscal_types.index(self.fiscal_type)]
  end


  def verify
    TaxpayerIdentification.find_by_idnumber(self.rnc).tap do |tax_id|
      self.verified = tax_id.present?
      if tax_id.present?
        self.company_name = tax_id.full_name || tax_id.company_name 
      else
        self.company_name = nil
      end
      self.save
    end
  end
end
