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

    it { should validate_presence_of :cart_id }
    it { should validate_presence_of :product_id }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of :quantity }
    it { should belong_to :cart }
    it { should belong_to :product }

  end

  describe 'Option parsing' do
    
      let!(:category) { create :category }
      let!(:product_holder) { create :product, productcode: 'TEST', category: category, options: 'X' }
      let!(:options_item_x) { create :product, productcode: 'X', category: category, options: 'OPTION' }
      let!(:options_item_sidble) { create :product, productcode: 'SIDBLE', category: category, options: 'OPTION' }
    

    ['','0.75','1.5','2','3'].each do |q|
      ['X','SIDBLE'].each do |p|
        it "should parse a #{p} with #{q} as quantity" do
          q = 1 if q == ''
          q = (q.to_f == q.to_i) ? q.to_i : q.to_f
          build( :cart_product, :options => "#{q.to_f}#{p}", :product => product_holder).parsed_options.should include(quantity: q, code: p, part: 'W')
        end

        it "should show niffty #{p} with #{q} as quantity" do
          q = ''
          build(:cart_product, :options => "#{q}#{p}", :product => product_holder).niffty_options.should match("#{q}#{Product.find_by_productcode(p).productname}")
        end

      end
    end

    it "Should parse a product with sides" do
      pending('Missing test code')
    end

  end

  describe '.products_mix' do
    pending('Missing test code')
  end

  describe '.total_items_sold' do
    pending('Missing test code')
  end

  describe '#available_in_store?' do
    pending('Missing test code')
  end

end
