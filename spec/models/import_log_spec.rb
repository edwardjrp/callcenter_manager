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

require 'spec_helper'

describe ImportLog do
  it{ should validate_presence_of :log_type }
  it{ should validate_presence_of :state }
  it{ should have_many :import_events }
end
