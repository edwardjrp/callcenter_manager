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
  validates :name, presence: true, uniqueness: true
  validates :csv_file, :pdf_file, presence: true
  mount_uploader :csv_file, ReportUploader
  mount_uploader :pdf_file, ReportUploader
  scope :detailed, where(:name=>'Detallado')
  scope :sumary, where(:name=>'Consolidado')
  scope :coupons, where(:name=>'Cupones')
  scope :discounts, where(:name=>'Descuentos')
  scope :products_mix, where(:name=>'ProductsMix')
  scope :per_hour, where(:name=>'PorHora')

  def self.report_types
    %W( Detallado Consolidado Cupones Descuentos ProductsMix PorHora)
  end

  def output_file_name
     "reporte-#{self.name}-#{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}"
  end

  def self.available_reports
    [:detailed_report, :sumary_report, :coupons_report, :discounts_report, :product_mix_report, :per_hour_report]
  end

  def generate(start_time, end_time, options = {})
    case self.name
    when 'Detallado'
      completed_detailed_carts = Cart.complete_in_date_range(start_time, end_time)
      abandoned_detailed_carts = Cart.abandoned_in_date_range(start_time, end_time)
      if options[:agent]
        agent_query = Cart.joins(:user).where('users.first_name = ? OR users.last_name = ? OR users.idnumber = ?', "%#{options[:agent]}%", "%#{options[:agent]}%", "%#{options[:agent]}%")
        completed_detailed_carts = completed_detailed_carts.merge(agent_query) 
        abandoned_detailed_carts = abandoned_detailed_carts.merge(agent_query)
      end
      detailed_carts = completed_detailed_carts + abandoned_detailed_carts
      process_detailed(detailed_carts, start_time, end_time)
    end
    self
  end

  private

  def process_detailed(relation, start_time, end_time)
    detailed_report = Reports::Generator.new relation, :detailed_report, start_time, end_time,  :landscape do |cart|
      [
        cart.id,
        cart.store_info_id.to_s,
        cart.new_client?,
        cart.client_info,
        cart.completion_info,
        cart.service_method,
        cart.agent_info,
        cart.take_time_info,
        Reports::Generator.monetize(cart.payment_amount),
        cart.payment_type,
        cart.fiscal_type,
        cart.order_progress,
        cart.state,
        cart.products.map(&:name).to_sentence
      ]
    end
    csv_temp_file = Tempfile.new(["reporte detallado", '.csv'])
    csv_temp_file.write(detailed_report.render_csv)
    pdf_temp_file = Tempfile.new(["reporte detallado", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(detailed_report.render_pdf)
    self.csv_file = csv_temp_file
    self.pdf_file = pdf_temp_file
    self.save
    ensure
      csv_temp_file.close!
      pdf_temp_file.close!
  end

  # def process_sumary(relation, start_date, end_date)
  #   Rails.logger.debug start_date
  #   Rails.logger.debug end_date
  #   pdf_temp_file = Tempfile.new(["reporte consolidado", '.pdf'])
  #   pdf_temp_file.binmode
  #   pdf_temp_file.write(relation.pdf_sumary_report(start_date, end_date).render)
  #   self.pdf_file = pdf_temp_file
  #   self.save
  #   ensure pdf_temp_file.close!
  # end

  # def process_coupons(relation, start_date, end_date)
  #   pdf_temp_file = Tempfile.new(["reporte cupones", '.pdf'])
  #   pdf_temp_file.binmode
  #   pdf_temp_file.write(relation.pdf_coupons_report(start_date, end_date).render)
  #   self.pdf_file = pdf_temp_file
  #   self.save
  #   ensure pdf_temp_file.close!
  # end

  # def process_discounts(relation, start_date, end_date)
  #   pdf_temp_file = Tempfile.new(["reporte descuentos", '.pdf'])
  #   pdf_temp_file.binmode
  #   pdf_temp_file.write(relation.pdf_discounts_report(start_date, end_date).render)
  #   self.pdf_file = pdf_temp_file
  #   self.save
  #   ensure pdf_temp_file.close!
  # end

  # def process_products_mix(relation, start_date, end_date)
  #   pdf_temp_file = Tempfile.new(["reporte descuentos", '.pdf'])
  #   pdf_temp_file.binmode
  #   pdf_temp_file.write(relation.pdf_products_mix_report(start_date, end_date).render)
  #   self.pdf_file = pdf_temp_file
  #   self.save
  #   ensure pdf_temp_file.close!
  # end

end
