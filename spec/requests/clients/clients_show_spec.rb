#encoding: utf-8
require 'spec_helper'

describe "Client::Show" do
  describe "when show the client information", js:true do
    let!(:user) { create(:user) }
    let!(:street) { create :street }
    let!(:area) { street.area }
    let!(:city) { area.city }
    let!(:client) { create(:client, first_name: 'tester') }
    let!(:phone) { create :phone, client: client, number: '8095551234', ext: '99' }

    before(:each) do
      Capybara.current_driver = :selenium_chrome
      login( user )
      visit root_path 
      selector = '.ui-menu-item  a:first'
      fill_in "client_search_phone", with: '8095551234'
      sleep(1)
      page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
      page.find_by_id('client_search_phone').native.send_keys([:return])
    end

    subject { page } 
    
    after(:each)do
      Capybara.use_default_driver
    end

    it "should take to the show client page" do
      within('.subnav-fixed') { click_link(client.full_name) }
      should have_content('Información del cliente')
    end

    describe "whe editing the client" do

      before(:each) do
        within('.subnav-fixed') { click_link(client.full_name) }
      end

      it "should edit the name" do

        find("#best_in_place_client_#{client.id}_first_name").click
        should have_css('.form_in_place')
        within('.form_in_place'){ fill_in 'first_name', :with => 'Edited client' }
        page.execute_script("$('.form_in_place').find('input:first').trigger('blur')")
        within("#best_in_place_client_#{client.id}_first_name"){ should have_content 'Edited client' }

      end

      describe "when adding an address" do
        it "should render the add address link" do
          within('#addresses_list') { should have_content('Agregar') }
        end

        it "should show the add address modal" do
          within('#addresses_list') { click_link('Agregar') }
          should have_css('#add_address_modal', :visible => true)
        end

        it "should add an address to the client" do
          within('#addresses_list') { click_link('Agregar') }

          within('#add_address_modal')do 
            page.execute_script "$('#client_address_street').val('#{street.id}')"
            fill_in 'client_address_number', with: '1'
            select 'Casa', from: 'client_address_unit_type'
            fill_in 'client_address_unit_number', with: '1'
            fill_in 'client_address_postal_code', with: '1'
            fill_in 'client_address_delivery_instructions', with: '1'
            click_link 'Guardar'
          end

          page.should have_css('#add_address_modal', :visible => false)

          within('#addresses_list') do 

            should have_content(city.name)
            should have_content(area.name)
            should have_content(street.name)

          end

        end

      end

      describe "when adding a phone" do
        it "should render the add phone link" do
          within('#phones_list') { should have_content('Agregar') }
        end

        it "should show the add phone modal" do
          within('#phones_list') { click_link('Agregar') }
          should have_css('#add_phone_modal', :visible => true)
        end

        it "should add an phone to the client" do
          within('#phones_list'){ click_link('Agregar') }
          within('#add_phone_modal')do 
            fill_in 'client_phone_number', with: '8095652095'
            click_link 'Guardar'
          end
          should have_css('#add_phone_modal', :visible => false)
          within('#phones_list') do 
            page.should have_content('809-565-2095')
          end

        end

      end

    end

  end
  
end