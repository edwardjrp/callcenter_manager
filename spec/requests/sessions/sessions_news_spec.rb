#encoding: utf-8
require 'spec_helper'

describe "Sessions::News" do
  describe "when login in" do
    before(:each) do
      FactoryGirl.create :user, username: 'testname', :password=> "please"
      FactoryGirl.create :user, username: 'testadmin', :password=> "please", :roles => [:admin]
    end
    describe "operator login" do
      it "should render the login form and login" do
        visit login_path
        fill_in "username", with: 'testname'
        fill_in "password", with: 'please'
        click_button "Enviar"
        page.should have_content('Sesión iniciada')
      end
    
      it "should render the login link" do
        visit root_path
        within('ul.pull-right'){page.should have_content('Iniciar sesión')}
      end
    end
    
    describe "admin login" do
      it "login an redirect to the admin page" do
        visit login_path
        fill_in "username", with: 'testadmin'
        fill_in "password", with: 'please'
        click_button "Enviar"
        page.should have_content('Sesión iniciada')
        page.should have_content('Dashboard')
      end
    end
  end
end
