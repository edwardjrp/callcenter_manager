# == Schema Information
#
# Table name: import_events
#
#  id            :integer          not null, primary key
#  import_log_id :integer
#  name          :string(255)
#  subject       :string(255)
#  message       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe ImportEvent do
  it{ should validate_presence_of :import_log_id }
  it{ should validate_presence_of :name }
  it{ should validate_presence_of :subject }
  it{ should validate_presence_of :message }
  it{ should belong_to :import_log}
end
