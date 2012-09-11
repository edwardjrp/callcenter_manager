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
end
