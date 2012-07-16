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

    end
    
  end
  
       
end
