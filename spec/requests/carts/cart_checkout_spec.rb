#encoding: utf-8
require 'spec_helper'

describe "Cart checkout" do
  describe "when checking out" do
      before(:each) do
        login(FactoryGirl.create(:user))
        visit root_path 
      end
      
      it "should render the checkout link" do
        page.should have_css('#proceed_to_checkout_out')
      end
      
      it "should show the model", js: true do
        find('#proceed_to_checkout_out').click
        page.should have_css('#checkout_Modal', visible: true)
      end
      
  end
end