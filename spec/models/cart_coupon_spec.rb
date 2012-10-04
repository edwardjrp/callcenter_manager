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

require 'spec_helper'

describe CartCoupon do
  describe 'Validation' do
    it { should belong_to :cart }
    it { should belong_to :coupon }
  end
end
