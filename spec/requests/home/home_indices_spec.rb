#encoding: utf-8
require 'spec_helper'

describe "Home::Indices" do
  describe "when visiting the index path" do
    context "when the user is logged" do
      before(:each) do
        login(FactoryGirl.create(:user))
      end
      it "should render the main page" do
        visit root_path 
        page.should have_content('Clientes')
      end
    end
    
    context 'when user is not logged' do
      it "should redirect_to the login" do
        visit root_path
        page.should have_content('Debe iniciar sesión para continuar')
        page.should have_content('username')
        page.should have_content('password')
      end
    end
  end
end
