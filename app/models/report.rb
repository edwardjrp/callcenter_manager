# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  csv_file   :string(255)
#  pdf_file   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base
  attr_accessible :csv_file, :name, :pdf_file
  mount_uploader :csv_file, ReportUploader
  mount_uploader :pdf_file, ReportUploader

  def self.report_types
    %W( Detallado )
  end

  def self.detailed
    self.report_types[0]
  end
end
