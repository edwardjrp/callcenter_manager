# == Schema Information
#
# Table name: products
#
#  id                          :integer          not null, primary key
#  category_id                 :integer
#  productcode                 :string(255)
#  productname                 :string(255)
#  options                     :string(255)
#  sizecode                    :string(255)
#  flavorcode                  :string(255)
#  optionselectiongrouptype    :string(255)
#  productoptionselectiongroup :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class Product < ActiveRecord::Base
  belongs_to :category
  has_many :cart_products
  has_many :carts, :through=> :cart_products
  scope :are_option, where(:options=>'OPTION')
  scope :are_main, where('options != ?  or options is NULL', 'OPTION')
  # attr_accessible :title, :body
end
