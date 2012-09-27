#encoding: utf-8
require 'spec_helper'

describe 'Clients general' do
  let!(:user) { create :user, :admin }
  let!(:client) { create :client }
  let!(:cart) { create :cart, :client_id=> client.id, :user_id=> user.id }

  subject { page }
  before { login(user) }
  
  it "should render the clients link in the navbar" do
    visit admin_clients_path
    within('.subnav-fixed') { should have_content('Clientes') }
  end
  
  it "should render the clients list" do
    within('.navbar-fixed-top') { click_link('Gestión') }
    should have_css('#clients_list')
    should have_content(client.first_name)
  end
  
  it "show the client orders" do
    visit admin_clients_path
    within("#client_#{client.id}") do 
      should have_content('Detalles')
      click_link 'Detalles'
    end
    should have_css('#carts_list')
  end

  it "should render the ransack filter" do
    visit admin_clients_path
    should have_css('.filter')
  end

  # it "should render the import client link" do
  #   visit admin_clients_path
  #   page.should have_content('Clientes Olo')
  # end

  describe "when searching" do
    let(:search_client){ create :client,first_name: 'test user', last_name: 'test last name'}
    let(:search_phone){ create :phone, number: '8095652095', ext: '99', client_id: search_client.id }
    subject { page }

    it "should render the search form" do
      visit admin_clients_path
      should have_css('.form-search')
    end

    it "should delete a client" do
      pending('Spec pending')
    end

    it "should find the client from the phone" do 
      visit admin_clients_path
      fill_in 'q_phones_number_start', with: search_phone.number
      click_button 'Buscar'
      within('#clients_list') { should have_content(search_client.first_name) }
      within('#clients_list') { should_not have_content(client.first_name) }
    end
  end
end