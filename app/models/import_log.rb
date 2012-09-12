# == Schema Information
#
# Table name: import_logs
#
#  id         :integer          not null, primary key
#  log_type   :string(255)
#  state      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImportLog < ActiveRecord::Base
  has_many :import_events, dependent: :destroy
  validates :log_type, :state, presence: true
  accepts_nested_attributes_for :import_events
  attr_accessible :log_type, :state

  scope :products_import, where(log_type: 'products_import')
  scope :coupons_import, where(log_type: 'coupons_import')
  scope :rnc_import, where(log_type: 'rnc_import')

  def self.log_types
    %w( products_import coupons_import rnc_import )
  end

  def self.products_import
    self.log_types[0]
  end
  def self.coupons_import
    self.log_types[1]
  end
  def self.rnc_import
    self.log_types[2]
  end
end
