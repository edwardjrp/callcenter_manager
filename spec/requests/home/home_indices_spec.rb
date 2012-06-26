#encoding: utf-8
require 'spec_helper'

describe "Home::Indices" do
  describe "when visiting the index path" do
    context "when the user is logged" do
      before(:each) do
        login(FactoryGirl.create(:user))
        @client = FactoryGirl.create(:client, first_name: 'tester')
        @phone = FactoryGirl.create :phone, client: @client
        10.times{FactoryGirl.create(:client)}
        visit root_path 
        
      end
      it "should render the main page" do
        page.should have_content('Clientes')
      end
       
       it "should show the find user by phone form" do
         page.should have_css('#client_search')
       end
       
       it "should find the users in the list", js: true do
         fill_in "client_search_phone", with: '8095551234'
         within('#client_listing'){page.should have_content('tester')}
       end
    end
    
    context 'when user is not logged' do
      it "should redirect_to the login" do
        visit root_path
        page.should have_content('Debe iniciar sesión para continuar')
        page.should have_css('#sessions')
      end
    end
  end
end
