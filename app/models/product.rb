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
  has_many :store_products
  scope :are_option, where(:options=>'OPTION')
  scope :are_main, where('options != ?  or options is NULL', 'OPTION')
  # attr_accessible :title, :body
  
  def available_options
    return [] if category.nil?
    category.products.are_option
  end
  
  def parsed_options
    return [] if category.nil?
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
         "#{opt[:quantity]}#{self.class.find_by_productcode(opt[:code]).try(:productname)}-#{opt[:part]}"
       else
         "#{opt[:quantity]}#{self.class.find_by_productcode(opt[:code]).try(:productname)}"       
       end
      end.to_sentence
    end
  end
end
