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

class CartProduct < ActiveRecord::Base
  attr_accessible :bind_id, :cart_id, :options, :product_id, :quantity
end
