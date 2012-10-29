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
  scope :sumary, where(:name=>'Consolidado')
  scope :coupons, where(:name=>'Cupones')
  scope :discounts, where(:name=>'Descuentos')
  scope :products_mix, where(:name=>'ProductsMix')

  def self.report_types
    %W( Detallado Consolidado Cupones Descuentos ProductsMix )
  end

  def output_file_name
     "reporte-#{self.name}-#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}"
  end

  def process_detailed(relation)
    csv_temp_file = Tempfile.new(["reporte detallado", '.csv'])
    csv_temp_file.write(relation.to_csv)
    pdf_temp_file = Tempfile.new(["reporte detallado", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(relation.pdf_detailed_report.render)
    self.csv_file = csv_temp_file
    self.pdf_file = pdf_temp_file
    self.save
    ensure
      csv_temp_file.close!
      pdf_temp_file.close!
  end

  def process_sumary(relation, start_date, end_date)
    pdf_temp_file = Tempfile.new(["reporte consolidado", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(relation.pdf_sumary_report(start_date, end_date).render)
    self.pdf_file = pdf_temp_file
    self.save
    ensure pdf_temp_file.close!
  end

  def process_coupons(relation, start_date, end_date)
    pdf_temp_file = Tempfile.new(["reporte cupones", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(relation.pdf_coupons_report(start_date, end_date).render)
    self.pdf_file = pdf_temp_file
    self.save
    ensure pdf_temp_file.close!
  end

  def process_discounts(relation, start_date, end_date)
    pdf_temp_file = Tempfile.new(["reporte descuentos", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(relation.pdf_discounts_report(start_date, end_date).render)
    self.pdf_file = pdf_temp_file
    self.save
    ensure pdf_temp_file.close!
  end

  def process_products_mix(relation, start_date, end_date)
    pdf_temp_file = Tempfile.new(["reporte descuentos", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(relation.pdf_products_mix_report(start_date, end_date).render)
    self.pdf_file = pdf_temp_file
    self.save
    ensure pdf_temp_file.close!
  end

end
