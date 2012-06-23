#encoding: utf-8
require 'spec_helper'

describe "Sessions::News" do
  describe "when login in" do
    before(:each) do
      FactoryGirl.create :user, username: 'testname', :password=> "please"
    end
    it "should render the login form" do
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
end
