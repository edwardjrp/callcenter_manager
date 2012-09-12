#encoding:utf-8
require 'spec_helper'

describe 'Services general' do
  let!(:admin) {create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]}
  
  context "when logged as an admin" do
    before(:each) do
      login(admin)
    end

    it 'should render the settings list' do
      visit admin_root_path
      within('.navbar-fixed-top'){page.should have_content('Administración')}
      within('.navbar-fixed-top'){click_link('Administración')}
      within('.subnav'){page.should have_content('Importación de productos')}
    end

    

  end
end