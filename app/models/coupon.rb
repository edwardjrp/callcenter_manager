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


  def coupon_products
    ActiveSupport::JSON.decode(target_products).map{ |cp| { product: Product.find_by_productcode(cp['product_code']), quantity: cp['minimun_require'].to_i }}
  end
end
