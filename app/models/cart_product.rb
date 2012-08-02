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
#  priced_at  :decimal(, )
#

class CartProduct < ActiveRecord::Base
  validates :cart_id, :presence=>true
  validates :product_id, :presence=>true
  validates :quantity, :presence=>true
  validates :quantity, :numericality=>true
  belongs_to :cart
  belongs_to :product
  attr_accessible :bind_id, :cart_id, :options, :product_id, :quantity
  
  
  def parsed_options
    return [] if product.category.nil?
    if options.present? and options.split(',').any?
      options_result = []
      options.split(',').each do |opt|
        code_match = opt.match(/^([0-9]{0,2}\.?[0|7|5]{0,2})([A-Z]{1,}[a-z]{0,})(?:\-([L12]))?/)
        quantity = code_match[1] || '1'
        code = code_match[2]
        part = code_match[3] || 'W'
        options_result.push({ quantity: quantity, code: code, part: part })
      end
      return options_result
    end
  end
  
  def niffty_options
    if parsed_options.present?
      parsed_options.map do |opt|
       if opt[:part] != 'W'
         "#{opt[:quantity]}#{Product.find_by_productcode(opt[:code]).try(:productname)}-#{opt[:part]}"
       else
         "#{opt[:quantity]}#{Product.find_by_productcode(opt[:code]).try(:productname)}"       
       end
      end.to_sentence
    end
  end
end
