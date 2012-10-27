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
  attr_accessible :cart_id, :user_id

  def info
    return "id #{cart.id} - #{cart.client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')} - #{cart.client.last_phone.ext}" if  cart.client.present? && cart.client.last_phone.present? && cart.client.last_phone.ext.present?
    return "id #{cart.id} - #{cart.client.last_phone.number.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,'\\1-\\2-\\3')}" if  cart.client.present? && cart.client.last_phone.present?
    "id #{cart.id}"
  end
end
