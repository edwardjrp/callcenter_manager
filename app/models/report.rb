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
      completed_detailed_carts = Cart.complete_in_date_range(start_time, end_time).untrashed
      abandoned_detailed_carts = Cart.abandoned_in_date_range(start_time, end_time).untrashed
      if options[:agent]
        agent_query = Cart.joins(:user).where('users.first_name = ? OR users.last_name = ? OR users.idnumber = ?', "%#{options[:agent]}%", "%#{options[:agent]}%", "%#{options[:agent]}%")
        completed_detailed_carts = completed_detailed_carts.merge(agent_query)
        abandoned_detailed_carts = abandoned_detailed_carts.merge(agent_query)
      end
      detailed_carts = completed_detailed_carts + abandoned_detailed_carts
      process_detailed(detailed_carts, start_time, end_time)
    when 'ProductsMix'
      process_products_mix(CartProduct.products_mix(start_time, end_time, options), start_time, end_time)
    when 'Cupones'
      process_coupons(Cart.complete_in_date_range(start_time, end_time).joins(:coupons).group('coupons.code').count, start_time, end_time)
    when 'Descuentos'
      process_discounts(Cart.complete_in_date_range(start_time, end_time).discounted, start_time, end_time)
    when 'Consolidado'
      process_sumary(Cart.scoped, start_time, end_time)
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

  def process_products_mix(relation, start_time, end_time)
    product_mix_report = Reports::Generator.new relation, :product_mix_report, start_time, end_time,  :landscape do |product, cart_products|
      [
        '',
        product.name,
        product.sizecode,
        product.flavorcode,
        Reports::Generator.monetize(cart_products.sum(&:priced_at)),
        cart_products.sum(&:quantity),
        Reports::Generator.percentize(cart_products.sum(&:priced_at).to_d / Cart.total_sells_in(start_time, end_time)),
        Reports::Generator.percentize(cart_products.sum(&:quantity).to_d / CartProduct.total_items_sold(start_time, end_time)),
        product.carts.complete_in_date_range(start_time, end_time).count,
        Reports::Generator.percentize(product.carts.complete_in_date_range(start_time, end_time).count.to_d / Cart.completed.date_range(start_time, end_time).count.to_d)
      ]
    end
    csv_temp_file = Tempfile.new(["reporte products mix", '.csv'])
    csv_temp_file.write(product_mix_report.render_csv)
    pdf_temp_file = Tempfile.new(["reporte products mix", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(product_mix_report.render_pdf)
    self.csv_file = csv_temp_file
    self.pdf_file = pdf_temp_file
    self.save
    ensure
      csv_temp_file.close!
      pdf_temp_file.close!
  end

  def process_coupons(relation, start_time, end_time)
    coupons_report = Reports::Generator.new relation, :coupons_report, start_time, end_time do |coupon_code, coupon_count|
      [
        coupon_code,
        Coupon.where(code: coupon_code).first.description_info,
        coupon_count,
        Reports::Generator.percentize(coupon_count.to_d / Cart.completed.count.to_d) ,
        Reports::Generator.percentize(coupon_count.to_d / Cart.completed.joins(:coupons).count.to_d)
      ]
    end
    csv_temp_file = Tempfile.new(["reporte cupones", '.csv'])
    csv_temp_file.write(coupons_report.render_csv)
    pdf_temp_file = Tempfile.new(["reporte cupones", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(coupons_report.render_pdf)
    self.csv_file = csv_temp_file
    self.pdf_file = pdf_temp_file
    self.save
    ensure
      csv_temp_file.close!
      pdf_temp_file.close!
  end

  def process_discounts(relation, start_time, end_time)
    discounts_report = Reports::Generator.new relation, :discounts_report, start_time, end_time do |cart|
      [
        cart.agent_info,
        cart.agent_info_name,
        cart.discount_authorizer,
        cart.discount_authorizer_name,
        cart.completion_info,
        cart.store_info_id,
        cart.complete_id,
        cart.client_info,
        Reports::Generator.monetize(cart.payment_amount),
        Reports::Generator.monetize(cart.discount),
        Reports::Generator.monetize((cart.payment_amount.to_d - cart.discount.to_d))
      ]
    end
    csv_temp_file = Tempfile.new(["reporte cupones", '.csv'])
    csv_temp_file.write(discounts_report.render_csv)
    pdf_temp_file = Tempfile.new(["reporte cupones", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(discounts_report.render_pdf)
    self.csv_file = csv_temp_file
    self.pdf_file = pdf_temp_file
    self.save
    ensure
      csv_temp_file.close!
      pdf_temp_file.close!
  end

  def process_sumary(relation, start_time, end_time)
    sumary_report =  Reports::Generator.new Cart.scoped, :sumary_report, start_time, end_time do | product, product_count |
      [ product, product_count ]
    end
    csv_temp_file = Tempfile.new(["reporte Consolidado", '.csv'])
    csv_temp_file.write(sumary_report.render_csv)
    pdf_temp_file = Tempfile.new(["reporte Consolidado", '.pdf'])
    pdf_temp_file.binmode
    pdf_temp_file.write(sumary_report.render_pdf)
    self.csv_file = csv_temp_file
    self.pdf_file = pdf_temp_file
    self.save
  end
end
