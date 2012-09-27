#encoding: utf-8
require 'spec_helper'

describe "Sessions::End" do

  describe "when login out" do
    let!(:user) { create :user, username: 'testname', :password=> "please" }

    subject { page }

    before(:each) do
      visit login_path
      fill_in "username", with: 'testname'
      fill_in "password", with: 'please'
      click_button "Enviar"
    end

    it "should render the logout link" do

      within('.pull-right') do
        page.should have_content(user.full_name)
        page.should have_content('Cerrar Sesión')
      end

    end
    
    it "should close the session" do
      visit root_path
      within('ul.pull-right') { click_link('Cerrar Sesión') }
      should have_content('Sesión terminada')
    end

  end

end