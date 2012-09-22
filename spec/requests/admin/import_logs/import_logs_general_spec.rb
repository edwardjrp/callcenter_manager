#encoding:utf-8
require 'spec_helper'

describe 'Services general' do
  let!(:admin) {create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]}
  
  context "when logged as an admin" do
    before(:each) do
      login(admin)
    end

    it 'should render the settings list' do
      visit admin_stores_path
      within('.subnav'){page.should have_content('Importación')}
    end

    

  end
end