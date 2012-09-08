#encoding:utf-8
require 'spec_helper'

describe 'Addresse general' do
  
  context "when logged as an admin" do
    let(:admin){create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]}

    before(:each) do
      login(admin)
      visit admin_addresses_path
    end

    it 'test functionality' do
      pending
    end

    
  end
end