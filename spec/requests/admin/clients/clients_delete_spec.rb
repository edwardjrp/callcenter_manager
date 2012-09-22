#encoding: utf-8
require 'spec_helper'

describe 'Clients general' do
  let!(:user) { create :user, :roles=>[:admin] }
  let!(:client) { create :client }
  let!(:client2) { create :client }
  let!(:cart) { create :cart, client: client2 , completed: true}

  before { login(user) }
  subject { page }
    
  it "should remove the client from the list", js: true do
    visit admin_clients_path
    within("#client_#{client.id}") { click_link('Eliminar') }
    should_not have_content(client.first_name)
  end

  it "should not remove the client from the list if it has completed carts", js: true do
    visit admin_clients_path
    within("#client_#{client2.id}") { click_link('Eliminar') }
    should have_content(client2.first_name)
    should have_content('Algunas ordenes hacen referencia a este cliente')
  end
end