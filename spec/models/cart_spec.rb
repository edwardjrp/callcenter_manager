# == Schema Information
#
# Table name: carts
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  client_id                 :integer
#  communication_failed      :boolean          default(FALSE)
#  status_text               :string(255)
#  store_id                  :integer
#  store_order_id            :string(255)
#  service_method            :string(255)
#  business_date             :datetime
#  advance_order_time        :datetime
#  net_amount                :decimal(, )
#  tax_amount                :decimal(, )
#  tax1_amount               :decimal(, )
#  tax2_amount               :decimal(, )
#  payment_amount            :decimal(, )
#  message                   :string(255)
#  order_text                :string(255)
#  order_progress            :string(255)
#  can_place_order           :boolean
#  delivery_instructions     :text
#  payment_type              :string(255)
#  credit_cart_approval_name :string(255)
#  fiscal_number             :string(255)
#  fiscal_type               :string(255)
#  company_name              :string(255)
#  discount                  :decimal(, )
#  discount_auth_id          :integer
#  completed                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'spec_helper'

describe Cart do
  context 'Validation' do
    it{should validate_presence_of :user_id}
    it{should belong_to :user}
    it{should belong_to :client}
    it{should belong_to :store}
  end
end
