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

require 'spec_helper'

describe CartProduct do
  describe "Validation" do
    it{should validate_presence_of :cart_id}
    it{should validate_presence_of :product_id}
    it{should validate_presence_of :quantity}
    it{should validate_numericality_of :quantity}
    it{should belong_to :cart}
    it{should belong_to :product}
  end

  describe 'Option parsing' do
    before(:each) do
      @category = FactoryGirl.create :category
      @product_holder = FactoryGirl.create :product, :productcode => 'TEST', :category=> @category, :options => 'X'
      @options_item = FactoryGirl.create :product, :productcode => 'X', :category=>@category, :options => 'OPTION'
      # @cart_product = FactoryGirl.attributes_for :cart_product, :options => 'X', :product => @xholder
    end

    ['','0.75','1.5','2','3'].each do |q|
      ['X','SIDBLE'].each do |p|
        it "should parse a #{p} with #{q} as quantity" do
          @cart_product = FactoryGirl.attributes_for :cart_product, :options => "#{q}#{p}", :product => @product_holder
          q = '1' if q == ''
          save_without_massasignment(CartProduct,@cart_product).parsed_options.should include(quantity: Float(q), code: p, part: 'W')
        end
      end
    end
  end
end
