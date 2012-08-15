require 'spec_helper'

describe 'Stores general' do
  before(:each)do
    @user = FactoryGirl.create :user, :roles=>[:admin]
    login(@user)
    @client = FactoryGirl.create :client
    @cart = FactoryGirl.create :cart, :client_id=> @client.id, :user_id=> @user.id
  end
  
  it "should render the clients link in the navbar" do
    within('.navbar-fixed-top'){page.should have_content('Clientes')}
  end
  
  it "should render the clients list" do
    within('.navbar-fixed-top'){click_link('Clientes')}
    page.should have_css('#clients_list')
    page.should have_content(@client.first_name)
  end
  
  it "show the client orders" do
    visit admin_clients_path
    within("#client_#{@client.id}") do 
      page.should have_content('Ordenes')
      click_link 'Ordenes'
    end
    page.should have_css('#carts_list')
  end

  it "should render the ransack filter" do
    visit admin_clients_path
    page.should have_content('.filter')
  end

  it "should render the import client link" do
    visit admin_clients_path
    page.should have_content('Clientes Olo')
  end
end