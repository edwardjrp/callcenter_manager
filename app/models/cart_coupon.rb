# == Schema Information
#
# Table name: cart_coupons
#
#  id              :integer          not null, primary key
#  cart_id         :integer
#  coupon_id       :integer
#  code            :string(255)
#  target_products :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class CartCoupon < ActiveRecord::Base
  belongs_to :cart
  belongs_to :coupon
  attr_accessible :cart_id, :code, :coupon_id, :target_products
end
