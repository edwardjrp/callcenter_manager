#encoding:utf-8
require 'spec_helper'

describe 'Dashboarn general' do
  before(:each) do 
    @admin = FactoryGirl.create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]
    @operator = FactoryGirl.create :user, :username=>'test', :password=>"please", :password_confirmation=>"please", :roles=>[:operator]
  end
  
  context "when logged as an admin" do
    before(:each) do
      login(@admin)
    end
    it 'should not render the user info bar' do
      page.should_not have_css('.subnav')
    end
    it 'should not allow access to the general seccion' do
      visit root_path
      page.should have_content('No tiene permitido el acceso esta sección')
    end
    
  end
end