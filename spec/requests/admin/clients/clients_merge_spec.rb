#encoding: utf-8
require 'spec_helper'

describe 'Cleints merge' do
  before(:each)do
    @user = FactoryGirl.create :user, :roles=>[:admin]
    login(@user)
    @client1 = FactoryGirl.create :client
    @phone1 = FactoryGirl.create :phone, client: @client1
    @client2 = FactoryGirl.create :client
    @phone2 = FactoryGirl.create :phone, client: @client2
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

  it "should merge 2 clients", js: true do
    visit merge_admin_clients_path
    within('.swMain') do
      within('#target_client_search') do 
        fill_in 'q_idnumber_cont', with: @client1.idnumber
        click_button 'Buscar'
      end
      within('#choose_destination_client') do 
        page.should have_content(@client1.first_name)
        find('.client_selection:first').click
      end
      click_link('Siguiente')
      page.should have_css('#source_client_search', visible: true)
      within('#source_client_search') do 
        fill_in 'q_idnumber_cont', with: @client2.idnumber
        click_button 'Buscar'
      end
      within('#choose_source_client') do 
        page.should have_content(@client2.first_name)
        find('.client_selection:first').click
      end
      click_link('Siguiente')
      page.should have_css('#client_personal_data_merge', visible: true)
      page.should have_content('Teléfonos')
      within('#client_personal_data_merge') do
        find("input[name='client_merge_first_name']:first").click
        find("input[name='client_merge_last_name']:first").click
        find("input[name='client_merge_idnumber']:first").click
        find("input[name='client_merge_email']:first").click
        find(".merge_phone_selection:first").click
      end
      click_link('Siguiente')
      page.should have_css('#merge_client_confirmation', visible: true)
    end
  end
end