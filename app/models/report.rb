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
  scope :detailed, where(:name=>'Detallado')

  def self.report_types
    %W( Detallado )
  end

  def output_file_name
     "reporte-#{self.name}-#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}"
  end

  def process(relation)
    csv_temp_file = Tempfile.new(["reporte detallado", '.csv'])
    csv_temp_file.write(relation.to_csv)
    pdf = Prawn::Document.new(top_margin: 70, :font_size => 10, :page_layout => :landscape)
    pdf_temp_file = Tempfile.new(["reporte detallado", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(relation.pdf_detailed_report.render)
    self.csv_file = csv_temp_file
    self.pdf_file = pdf_temp_file
    self.save
  end

end
