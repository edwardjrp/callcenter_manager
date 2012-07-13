# == Schema Information
#
# Table name: cart_products
#
#  id         :integer          not null, primary key
#  cart_id    :integer
#  quantity   :decimal(, )
#  product_id :integer
#  bind_id    :integer
#  options    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe CartProduct do
  describe "Validation" do
    it{should validate_presence_of :cart_id}
    it{should validate_presence_of :product_id}
    it{should validate_presence_of :quantity}
    it{should validate_numericality_of :quantity}
    it{should belong_to :cart}
    it{should belong_to :product}
  end
end
