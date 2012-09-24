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
