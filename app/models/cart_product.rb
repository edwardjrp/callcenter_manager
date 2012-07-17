# == Schema Information
#
# Table name: cart_products
#
#  id         :integer          not null, primary key
#  cart_id    :integer
#  quantity   :integer
#  product_id :integer
#  bind_id    :integer
#  options    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CartProduct < ActiveRecord::Base
  validates :cart_id, :presence=>true
  validates :product_id, :presence=>true
  validates :quantity, :presence=>true
  validates :quantity, :numericality=>true
  belongs_to :cart
  belongs_to :product
  attr_accessible :bind_id, :cart_id, :options, :product_id, :quantity
end
