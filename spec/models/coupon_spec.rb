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
#

require 'spec_helper'

describe Coupon do
  pending "add some examples to (or delete) #{__FILE__}"
end
