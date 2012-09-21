require 'spec_helper'

describe 'Clients general' do
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
      page.should have_content('Detalles')
      click_link 'Detalles'
    end
    page.should have_css('#carts_list')
  end

  it "should render the ransack filter" do
    visit admin_clients_path
    page.should have_css('.filter')
  end

  # it "should render the import client link" do
  #   visit admin_clients_path
  #   page.should have_content('Clientes Olo')
  # end

  describe "when searching" do
    let(:search_client){ FactoryGirl.create :client,first_name: 'test user', last_name: 'test last name'}
    let(:search_phone){ FactoryGirl.create :phone, number: '8095652095', ext: '99', client_id: search_client.id}
    

    it "should render the search form" do
      visit admin_clients_path
      page.should have_css('.form-search')
    end

    it "should delete a client" do
      pending('Spec pending')
    end

    it "should find the client from the phone" do 
      visit admin_clients_path
      fill_in 'q_phones_number_start', with: search_phone.number
      click_button 'Buscar'
      within('#clients_list'){page.should have_content(search_client.first_name)}
      within('#clients_list'){page.should_not have_content(@client.first_name)}
    end
  end
end