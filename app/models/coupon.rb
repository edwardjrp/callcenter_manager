class Coupon < ActiveRecord::Base
  attr_accessible :code, :custom_description, :description, :discontinued, :effective_date, :effective_days, :enable, :expiration_date, :generated_description, :hidden, :minimum_price, :order_sources, :secure, :service_methods
end
