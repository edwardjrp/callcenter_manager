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
  
  
  def available_in_store(store)
    store.products.include?(self.product)
  end

  def parsed_options
    return [] if product && product.category.nil?
    if options.present? and options.split(',').any?
      options_result = []
      options.split(',').each do |opt|
        options_result.push(Option.new(product.category, opt).to_hash)
      end
      options_result
    end
  end
  
  def niffty_options
    return [] if product && product.category.nil?
    if options.present? and options.split(',').any?
      options.split(',').map do |opt|
        Option.new(product.category, opt).to_s
      end.to_sentence
    end
  end

end
