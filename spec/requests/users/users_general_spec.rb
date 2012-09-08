#encoding:utf-8
require 'spec_helper'

describe 'Users general' do
  let!(:operator){create :user, :username=>'opt', :password=>"please", :password_confirmation=>"please", :roles=>[:operator]}

  context "when logged as an admin" do
    before(:each) do
      login(operator)
      visit root_path
    end

    it 'should render the users list with their roles' do
      page.should have_content('Mis Ordenes')
    end    
  end
end