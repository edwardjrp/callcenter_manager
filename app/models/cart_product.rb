# == Schema Information
#
# Table name: cart_products
#
#  id                    :integer          not null, primary key
#  cart_id               :integer
#  quantity              :integer
#  product_id            :integer
#  bind_id               :integer
#  options               :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  priced_at             :decimal(, )
#  coocking_instructions :string(255)
#

class CartProduct < ActiveRecord::Base
  validates :cart_id, :presence=>true
  validates :product_id, :presence=>true
  validates :quantity, :presence=>true
  validates :quantity, :numericality=>true
  belongs_to :cart
  belongs_to :product
  attr_accessible :bind_id, :cart_id, :options, :product_id, :quantity
  
  def self.products_mix(start_date, end_date)
    mix = joins(:cart).where('carts.completed = true AND carts.message_mask != 4').where('carts.created_at > ? and carts.created_at < ?', start_date, end_date).group_by { |cart_product| cart_product.product_id }
    results = []
    mix.each do |product_id, cart_products|
      if exists? product_id
        current_product = Product.find(product_id)
        results.push( product: current_product, total_carts: Cart.completed.date_range(start_date, end_date).joins(:products).where('products.id = ?', current_product.id).count ,cart_products: { total_sales: cart_products.sum{ |cp| cp.priced_at || 0 }, total_count: cart_products.sum(&:quantity)})
      end
    end
    results.group_by{ | current_product | current_product[:product].category.name }
  end

  def self.total_items_sold(start_date, end_date)
    joins(:cart).where('carts.completed = true AND carts.message_mask != 4').where('carts.created_at > ? and carts.created_at < ?', start_date, end_date).select('SUM(cart_products.quantity) as total_sales').first.total_sales.to_i
  end

  def available_in_store(store)
    store.products.include?(self.product)
  end

  def combined_product_name
    return '' if product_id.nil?
    return "Mitad #{product.productname} y mitad #{Product.find(bind_id).productname}".html_safe if bind_id and Product.exists? bind_id
    
    product.productname.html_safe
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
