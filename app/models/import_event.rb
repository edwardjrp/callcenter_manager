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

class ImportEvent < ActiveRecord::Base
  validates :import_log_id, :name, :subject, :message, presence: true
  belongs_to :import_log
  attr_accessible :import_log_id, :message, :name, :subject

  
end
