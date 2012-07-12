#encoding:utf-8
require 'spec_helper'

describe 'Categories general' do
  before(:each)do
    login(FactoryGirl.create :user, :roles=>[:admin])
    @category = FactoryGirl.create :category, :name=>'test category'
  end
  
  it "should render de link in the main nav" do
    visit admin_root_path
    within('.navbar-fixed-top'){page.should have_content('Categorías')}
  end
  
  it "should display the categories template" do
    visit admin_categories_path
    page.should have_css('#categories')
  end
  
  it "should display the categories list" do
    visit admin_categories_path
    within('#categories_list'){page.should have_content('test category')}
  end
end