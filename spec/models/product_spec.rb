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
#  discontinued                :boolean          default(FALSE)
#

require 'spec_helper'

describe Product do
  describe "Validation" do

    it { should belong_to :category }
    it { should have_many(:carts).through(:cart_products) }
    it { should have_many :cart_products }
    it { should have_many :store_products }
    it { should have_many(:stores).through(:store_products) }

  end

  describe '#name' do
    let!(:product) { build :product, productname: '8&quot; Tradicional Italiana'}

    it 'should return the unscaped productname' do
      product.name.should == '8" Tradicional Italiana'
    end
  end
  
end
