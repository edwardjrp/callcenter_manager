# == Schema Information
#
# Table name: user_carts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  cart_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserCart < ActiveRecord::Base
  belongs_to :user
  belongs_to :cart
  validates :user_id, presence: true
  validates :cart_id, presence: true
  attr_accessible :cart_id, :user_id

  def info
    return if self.cart.nil?
    return "id #{self.cart.id} - #{self.cart.client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')} - #{self.cart.client.last_phone.ext}" if  self.cart.client.present? && self.cart.client.last_phone.present? && self.cart.client.last_phone.ext.present?
    return "id #{self.cart.id} - #{self.cart.client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')}" if  self.cart.client.present? && self.cart.client.last_phone.present?
    "id #{self.cart.id}"
  end
end
