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

describe ProductsImport do
  let!(:soap_products) { File.read(Rails.root.join('spec','fixtures','store_products.xml')) }

  before do
    SoapClient.any_instance.should_receive(:get).and_return(soap_products)
  end
  
  describe '#perform' do
    it 'should lead the products to the database' do
      expect{ ProductsImport.new.perform }.to change { Product.count }.from(0)
    end

    it 'should lead the categories to the database' do
      expect{ ProductsImport.new.perform }.to change { Category.count }.from(0)
    end

    it 'should not duplicate products' do
      expect{ ProductsImport.new.perform }.to change { Product.count }.from(0)
      product_count = Product.count
      expect{ ProductsImport.new.perform }.to_not change { Product.count }.from(product_count)
    end

    it 'should not diplicate HAM' do
      ProductsImport.new.perform
      pizza = Category.where(name: 'Pizza').first
      sand = Category.where(name: 'SAND').first
      pasta = Category.where(name: 'Pasta').first
      pizza.should_not be_nil
      sand.should_not be_nil
      pasta.should_not be_nil
      pizza.products.where(productcode: 'H').count.should == 1
      sand.products.where(productcode: 'H').count.should == 1
      pasta.products.where(productcode: 'H').count.should == 1
      ProductsImport.new.perform
      pizza.products.where(productcode: 'H').count.should == 1
      sand.products.where(productcode: 'H').count.should == 1
      pasta.products.where(productcode: 'H').count.should == 1
    end

    it 'should not diplicate Cheddar' do
      ProductsImport.new.perform
      pizza = Category.where(name: 'Pizza').first
      sand = Category.where(name: 'SAND').first
      pasta = Category.where(name: 'Pasta').first
      pizza.should_not be_nil
      sand.should_not be_nil
      pasta.should_not be_nil
      pizza.products.where(productcode: 'E').count.should == 1
      sand.products.where(productcode: 'E').count.should == 1
      pasta.products.where(productcode: 'E').count.should == 1
      ProductsImport.new.perform
      pizza.products.where(productcode: 'E').count.should == 1
      sand.products.where(productcode: 'E').count.should == 1
      pasta.products.where(productcode: 'E').count.should == 1
    end
  end
  
end
