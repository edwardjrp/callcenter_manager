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
  

  def self.completed_in_range(start_time, end_time)
    self.joins(:cart).where('carts.completed = ? AND carts.message_mask != 4', true).where('carts.complete_on > ? and carts.complete_on < ?', start_time, end_time)
  end

  def self.products_mix(start_time, end_time, options = {})
    mix = self.completed_in_range(start_time, end_time)
    if options
      agents = User.where('first_name ILIKE ? OR last_name ILIKE ? OR idnumber ILIKE ?', "%#{options['agent']}%", "%#{options['agent']}%", "%#{options['agent']}%").all if options['agent']
      mix = mix.merge(self.where('carts.user_id IN (?)', agents.map(&:id))) if agents.any?

      store = Store.where('storeid = ?', options['store'].to_i).first if options['store']
      mix = mix.merge(self.where('carts.store_id = ?', store.id)) if store
      
      items = Product.where('products.productname ILIKE ?', "%#{options['item']}%").all if options['item']
      mix = mix.merge(self.where('cart_products.product_id IN (?)', items.map(&:id))) if items.any?
      
    end
    mix = mix.group_by(&:product).group_by{ |product, cart_products| product.category }
  end

  def self.total_items_sold(start_time, end_time)
    joins(:cart).where('carts.completed = true AND carts.message_mask != 4').where('carts.complete_on > ? and carts.complete_on < ?', start_time, end_time).select('SUM(cart_products.quantity) as total_sales').first.total_sales.to_i
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
