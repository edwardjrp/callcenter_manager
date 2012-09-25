#encoding: utf-8
require 'spec_helper'

describe "Client::New" do
  
  describe "when creating a new client" do
    let!(:street) { create :street }
    let!(:area) { street.area }
    let!(:city) { area.city }

    before do
      Capybara.current_driver = :selenium_chrome
      login(create(:user))
      visit root_path 
    end

    after do
       Capybara.use_default_driver
    end
     
    it "should create a new client", js: true do
       fill_in "client_search_phone", with: '8095551234'
       fill_in "client_search_ext", with: '45'
       fill_in "client_search_first_name", with: 'Tester'
       fill_in "client_search_last_name", with: 'Last'
       fill_in "client_search_idnumber", with: '00113574388'
       fill_in "client_search_email", with: 'test@mail.com'
       # select  city.name, from:  'client_search_address_city'
       page.execute_script "$('#client_search_address_street').val('#{street.id}')"
       fill_in 'client_search_address_number', with: '1'
       select 'Casa', from: 'client_search_address_unit_type'
       fill_in 'client_search_address_unit_number', with: '1'
       fill_in 'client_search_address_postal_code', with: '1'
       fill_in 'client_search_address_delivery_instructions', with: '1'
       click_button 'Agregar cliente'
       page.should have_content('Cliente creado')
       page.should_not have_css('#client_search_email')
     end

     it "should create a new client from name and phone alone", js: true do
       fill_in "client_search_phone", with: '8095554321'
       fill_in "client_search_ext", with: '45'
       fill_in "client_search_first_name", with: 'Tester'
       fill_in "client_search_last_name", with: 'Last'
       click_button 'Agregar cliente'
       page.should have_content('Cliente creado')
       page.should_not have_css('#client_search_email')
     end
     
     it "should allow the creation of a new user with the same phone and different ext", js: true do
        fill_in "client_search_phone", with: '8095551234'
        fill_in "client_search_ext", with: '100'
        fill_in "client_search_first_name", with: 'tester'
        fill_in "client_search_last_name", with: 'Last'
        fill_in "client_search_email", with: 'test2@mail.com'
        # select  city.name, from:  'client_search_address_city'
        page.execute_script "$('#client_search_address_street').val('#{street.id}')"
        fill_in 'client_search_address_number', with: '1'
        select 'Casa', from: 'client_search_address_unit_type'
        fill_in 'client_search_address_unit_number', with: '1'
        fill_in 'client_search_address_postal_code', with: '1'
        fill_in 'client_search_address_delivery_instructions', with: '1'
        click_button 'Agregar cliente'
        page.should have_content('Cliente creado')
        page.should_not have_css('#client_search_email')
      end

     # this test does not pass when phones are the same
     it "should create clients in sequence", js: true do
       page.execute_script "$('.subnav-fixed').css('display', 'none')"
       page.execute_script "$('#utils').css('display', 'none')"
       fill_in "client_search_phone", with: '8095551234'
       fill_in "client_search_ext", with: '41'
       fill_in "client_search_first_name", with: 'Tester'
       fill_in "client_search_last_name", with: 'Last'
       fill_in "client_search_email", with: 'test1@mail.com'
       # select  city.name, from:  'client_search_address_city'
       page.execute_script "$('#client_search_address_street').val('#{street.id}')"
       fill_in 'client_search_address_number', with: '1'
       select 'Casa', from: 'client_search_address_unit_type'
       fill_in 'client_search_address_unit_number', with: '1'
       fill_in 'client_search_address_postal_code', with: '1'
       fill_in 'client_search_address_delivery_instructions', with: '1'
       click_button 'Agregar cliente'
       page.should have_content('Cliente creado')
       fill_in "client_search_phone", with: '8095431234'
       fill_in "client_search_ext", with: '42'
       fill_in "client_search_first_name", with: 'iester'
       fill_in "client_search_last_name", with: 'Last'
       fill_in "client_search_email", with: 'test2@mail.com'
       # select  city.name, from:  'client_search_address_city'
       page.execute_script "$('#client_search_address_street').val('#{street.id}')"
       fill_in 'client_search_address_number', with: '1'
       select 'Casa', from: 'client_search_address_unit_type'
       fill_in 'client_search_address_unit_number', with: '1'
       fill_in 'client_search_address_postal_code', with: '1'
       fill_in 'client_search_address_delivery_instructions', with: '1'
       click_button 'Agregar cliente'
       page.should have_content('Cliente creado')
        fill_in "client_search_phone", with: '8095341234'
        fill_in "client_search_ext", with: '43'
        fill_in "client_search_first_name", with: 'iester'
        fill_in "client_search_last_name", with: 'Last'
        fill_in "client_search_email", with: 'test3@mail.com'
        # select  city.name, from:  'client_search_address_city'
        page.execute_script "$('#client_search_address_street').val('#{street.id}')"
        fill_in 'client_search_address_number', with: '1'
        select 'Casa', from: 'client_search_address_unit_type'
        fill_in 'client_search_address_unit_number', with: '1'
        fill_in 'client_search_address_postal_code', with: '1'
        fill_in 'client_search_address_delivery_instructions', with: '1'
        click_button 'Agregar cliente'
       page.should have_content('Cliente creado')
       page.should_not have_css('#client_search_email')
     end
     
     it "should show the address input ", js: true do
        fill_in "client_search_phone", with: '8095551234'
        fill_in "client_search_ext", with: '41'
        page.should have_css('#client_search_address_city')
        page.should have_css('#client_search_address_area')
        page.should have_css('#client_search_address_street')
        page.should have_css('#client_search_address_number')
        page.should have_css('#client_search_address_unit_type')
        page.should have_css('#client_search_address_unit_number')
        page.should have_css('#client_search_address_postal_code')
        page.should have_css('#client_search_address_delivery_instructions')
     end
    
    
    describe "when validating" do
      let!(:client) { create(:client, first_name: 'tester') }
      let!(:phone) { create :phone, client: client, number: '8095551234', ext: '99' }
      
      it "should validate address if city or its childrens are selected" do
        pending('Test')
      end

      it "should show the missing name validation error for the user", js: true do
         fill_in "client_search_phone", with: '8095551234'
         fill_in "client_search_ext", with: '45'
         fill_in "client_search_first_name", with: ''
         fill_in "client_search_last_name", with: 'Last'
         fill_in "client_search_email", with: 'test@mail.com'
         # select  city.name, from:  'client_search_address_city'
         page.execute_script "$('#client_search_address_street').val('#{street.id}')"
         fill_in 'client_search_address_number', with: '1'
         select 'Casa', from: 'client_search_address_unit_type'
         fill_in 'client_search_address_unit_number', with: '1'
         fill_in 'client_search_address_postal_code', with: '1'
         fill_in 'client_search_address_delivery_instructions', with: '1'        
         click_button 'Agregar cliente'
         page.should have_content('en blanco')
       end

      it "should no longer show the missing address info validation error for the user", js: true do
        fill_in "client_search_phone", with: '8095551234'
        fill_in "client_search_ext", with: '45'
        fill_in "client_search_first_name", with: 'rad'
        fill_in "client_search_last_name", with: 'Last'
        fill_in "client_search_email", with: 'test@mail.com'
        click_button 'Agregar cliente'
        page.should_not have_content('Addresses')
        page.should_not have_content('en blanco')
      end                          

    end

  end

end