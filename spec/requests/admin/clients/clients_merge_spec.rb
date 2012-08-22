#encoding: utf-8
require 'spec_helper'

describe 'Cleints merge' do
  before(:each)do
    @user = FactoryGirl.create :user, :roles=>[:admin]
    login(@user)
    @client = FactoryGirl.create :client
    @cart = FactoryGirl.create :cart, :client_id=> @client.id, :user_id=> @user.id
  end

  it "should render the merge clients link" do
    visit admin_clients_path
    page.should have_content('Fusión de clientes')
  end

  it "should render the merge clients wizard" do
    visit admin_clients_path
    click_link('Fusión de clientes')
    page.should have_css('.swMain')
  end
end