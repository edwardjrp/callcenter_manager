#encoding:utf-8
require 'spec_helper'

describe 'Admin Carts general' do
  let!(:user) { create :user, :admin }

  subject { page }
  before { login( user ) }

   it "should render the carts link in the nav" do
    visit admin_root_path
    within('.navbar-fixed-top') { should have_content('Ordenes') }
   end

  it "should go to the carts index" do
    visit admin_root_path
    within('.navbar-fixed-top') { click_link('Ordenes') }
    should have_css('#carts_list')
  end
end