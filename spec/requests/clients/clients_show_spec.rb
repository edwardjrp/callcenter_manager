#encoding: utf-8
require 'spec_helper'

describe "Client::Show" do
  describe "when show the client information", js:true do
    before(:each) do
      Capybara.current_driver = :selenium_chrome
      login(FactoryGirl.create(:user))
      @street = FactoryGirl.create :street
      @area = @street.area
      @city = @area.city
      @client = FactoryGirl.create(:client, first_name: 'tester')
      @phone = FactoryGirl.create :phone, client: @client, number: '8095551234', ext: '99'
      visit root_path 
      selector = '.ui-menu-item  a:first'
      fill_in "client_search_phone", with: '8095551234'
      sleep(1)
      page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
      page.find_by_id('client_search_phone').native.send_keys([:return])
    end
    
    after(:each)do
      Capybara.use_default_driver
    end

    it "should take to the show client page" do
      within('.subnav-fixed'){click_link(@client.full_name)}
      page.should have_content('Información del cliente')
    end

    describe "whe editing the client" do
      before(:each) do
        within('.subnav-fixed'){click_link(@client.full_name)}
      end

      it "should edit the name" do
        find("#best_in_place_client_#{@client.id}_first_name").click
        page.should have_css('.form_in_place')
        within('.form_in_place'){ fill_in 'first_name', :with => 'Edited client'}
        page.execute_script("$('.form_in_place').find('input:first').trigger('blur')")
        within("#best_in_place_client_#{@client.id}_first_name"){ page.should have_content 'Edited client'}
      end


      it "should render the add address link" do
        within('#addresses_list'){page.should have_content('Agregar')}
      end

      it "should show the add address modal" do
        within('#addresses_list'){click_link('Agregar')}
        page.should have_css('#add_address_modal', :visible => true)
      end

       it "should add an address to the client" do
        within('#addresses_list'){click_link('Agregar')}
        within('#add_address_modal')do 
          page.execute_script "$('#client_address_street').val('#{@street.id}')"
          fill_in 'client_address_number', with: '1'
          select 'Casa', from: 'client_address_unit_type'
          fill_in 'client_address_unit_number', with: '1'
          fill_in 'client_address_postal_code', with: '1'
          fill_in 'client_address_delivery_instructions', with: '1'
          click_link 'Guardar'
        end
        page.should have_css('#add_address_modal', :visible => false)
        within('#addresses_list') do 
          page.should have_content(@city.name)
          page.should have_content(@area.name)
          page.should have_content(@street.name)
        end
      end
    end

  end
end