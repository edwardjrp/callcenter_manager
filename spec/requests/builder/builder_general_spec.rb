#encoding: utf-8
require 'spec_helper'

describe "Builder category" do
  before(:each) do
    # Capybara.current_driver = :selenium_chrome
    login(FactoryGirl.create(:user, :roles=>[:operator]))
  end
  # after(:each)do
  #   Capybara.use_default_driver
  # end
  context "when building", js: true do
    it "should render the surface" do
      visit builder_path 
      page.should have_selector('#surface')
    end
    
    context "when interfacing categories" do
      before(:each)do
        @category_with_options = FactoryGirl.create(:category, :has_options=>true)
        @category_without_options = FactoryGirl.create(:category)
      end
      
      it "should show the categories tab" do
        visit builder_path 
        within('.nav-tabs') do
          page.should have_content(@category_with_options.name)
          page.should have_content(@category_without_options.name)  
        end
      end
      
      context "when selection a product" do
        before(:each) do
          @product_with_options1 = FactoryGirl.create(:product, productname: 'test1 with it', category: @category_with_options)
          @product_with_options2 = FactoryGirl.create(:product,productname: 'test2 with it', category: @category_with_options)
          
          @product_options1 = FactoryGirl.create(:product, productname: 'test1 with it', productcode: 'C', category: @category_with_options, options: 'OPTION')
          @product_options2 = FactoryGirl.create(:product,productname: 'test2 with it', productcode: 'O', category: @category_with_options, options: 'OPTION')
          @product_options2 = FactoryGirl.create(:product,productname: 'test2 with it', productcode: 'X', category: @category_with_options, options: 'OPTION')
          
          @product_without_options1 = FactoryGirl.create(:product, productname: 'test1 without it', category: @category_without_options, options:'')
          @product_without_options2 = FactoryGirl.create(:product,productname: 'test2 without it', category: @category_without_options, options:'')
        end
        it "should the products for the corresponding category" do
          visit builder_path 
          within('.nav-tabs'){click_link(@category_with_options.name)}
          within('.tab-content'){page.should have_content('with it')}
        end
      end

    end
    
  end
  
       
end
