# encoding:utf-8
# == Schema Information
#
# Table name: coupons
#
#  id                    :integer          not null, primary key
#  code                  :string(255)
#  description           :text
#  custom_description    :text
#  generated_description :text
#  minimum_price         :decimal(, )
#  hidden                :boolean
#  secure                :boolean
#  effective_days        :string(255)
#  order_sources         :string(255)
#  service_methods       :string(255)
#  expiration_date       :date
#  effective_date        :date
#  enable                :boolean          default(TRUE)
#  discontinued          :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  target_products       :text
#

class Coupon < ActiveRecord::Base
  has_many :cart_coupons
  has_many :carts , through: :cart_coupons
  attr_accessible :code, :custom_description, :description, :discontinued, :effective_date, :effective_days, :enable, :expiration_date, :generated_description, :hidden, :minimum_price, :order_sources, :secure, :service_methods
  scope :available, where(discontinued: false) 
  before_destroy :ensure_not_referenced_by_any_cart

  # scope :efective, where(discontinued: true) 
  EFFECTIVE_DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]


  def effective_today?
     effective_days.present? ? effective_days.split('|').include?(EFFECTIVE_DAYS[Time.now.wday]) : true
  end

  def coupon_products
    ActiveSupport::JSON.decode(target_products).map{ |cp| { product: Product.find_by_productcode(cp['product_code']), quantity: cp['minimun_require'].to_i }}
  end

  private
    # Ensure that there are no cart_coupons referencing this product
    def ensure_not_referenced_by_any_cart
        if self.cart_coupons.count.zero?
          return true
       else
         errors.add(:base, 'Este cupón aun esta presente en una orden')
         return false
       end
    end
end
