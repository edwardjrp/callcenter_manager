# == Schema Information
#
# Table name: cart_coupons
#
#  id              :integer          not null, primary key
#  cart_id         :integer
#  coupon_id       :integer
#  code            :string(255)
#  target_products :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe CartCoupon do
  pending "add some examples to (or delete) #{__FILE__}"
end
