#encoding:utf-8
require 'spec_helper'

describe 'Admin Carts general' do
  before(:each)do
    login(FactoryGirl.create :user, :roles=>[:admin])
  end

   it "should render the carts link in the nav" do
    visit admin_root_path
    within('.navbar-fixed-top'){page.should have_content('Ordenes')}
   end

  it "should go to the carts index" do
    visit admin_root_path
    within('.navbar-fixed-top'){click_link('Ordenes')}
    page.should have_css('#carts_list')
   end
end