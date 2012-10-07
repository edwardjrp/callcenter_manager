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
        pending('set to set up a cart for checkout')
      end
      
  end
end