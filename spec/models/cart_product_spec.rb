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

    # it "Should parse a product with sides" do
    #   pending('Missing test code')
    # end

  end

  describe '.completed_in_range' do
    let!(:start_time)   { Time.parse('2012-01-01 00:00:00 UTC') }
    let!(:reports_time) { Time.parse('2012-02-01 00:00:00 UTC') }
    let!(:end_time)     { Time.parse('2012-03-01 00:00:00 UTC') }

    let!(:cart1) { create :cart, completed: true, complete_on: reports_time }
    let!(:cart2) { create :cart, completed: true, complete_on: reports_time }
    let!(:cart3) { create :cart, completed: true, complete_on: Time.zone.now }

    let!(:complete_cart_products1) { create_list :cart_product, 2, cart: cart1, created_at: reports_time  }
    let!(:complete_cart_products2) { create_list :cart_product, 3, cart: cart2, created_at: reports_time  }
    let!(:complete_cart_products3) { create_list :cart_product, 2, cart: cart3, created_at: Time.zone.now }

    subject { CartProduct.completed_in_range(start_time, end_time) }

    it 'should return cart products from carts completed in the given time range' do
      CartProduct.completed_in_range(start_time, end_time).should =~ (complete_cart_products1 + complete_cart_products2)
      CartProduct.completed_in_range(start_time, end_time).should_not =~ complete_cart_products3
    end
  end

  describe '.products_mix' do
    let(:category1) { create :category }
    let(:category2) { create :category }

    let(:product1)  { create :product, category: category1 }
    let(:product2)  { create :product, category: category2 }
    let(:product3)  { create :product, category: category2 }
    let!(:products)  { [product1, product2, product3] }

    let!(:start_time)   { Time.parse('2012-01-01 00:00:00 UTC') }
    let!(:reports_time) { Time.parse('2012-02-01 00:00:00 UTC') }
    let!(:end_time)     { Time.parse('2012-03-01 00:00:00 UTC') }

    let!(:cart1) { create :cart, completed: true, complete_on: reports_time }
    let!(:cart2) { create :cart, completed: true, complete_on: reports_time }
    let!(:cart3) { create :cart, completed: true, complete_on: Time.zone.now }

    let!(:complete_cart_products1) { create_list :cart_product, 2, cart: cart1, product: products[0], created_at: reports_time  }
    let!(:complete_cart_products2) { create_list :cart_product, 3, cart: cart2, product: products[1], created_at: reports_time  }
    let!(:complete_cart_products3) { create_list :cart_product, 2, cart: cart3, product: products[2], created_at: Time.zone.now }

    it 'should include a list of products grouped by category' do
      CartProduct.products_mix(start_time, end_time).should include(category1 => [[product1, complete_cart_products1]])
    end
  end

  describe '.total_items_sold' do
    pending('Missing test code')
  end

  describe '#available_in_store?' do
    pending('Missing test code')
  end

end
