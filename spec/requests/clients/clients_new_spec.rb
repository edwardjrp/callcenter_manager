#encoding: utf-8
require 'spec_helper'

describe "Client::New" do
  describe "when creating a new client" do
      before(:each) do
        Capybara.current_driver = :selenium_chrome
        login(FactoryGirl.create(:user))
        visit root_path 
      end
      
      after(:each)do
         Capybara.use_default_driver
      end
       
      it "should create a new client", js: true do
         fill_in "client_search_phone", with: '8095551234'
         fill_in "client_search_ext", with: '45'
         fill_in "client_search_first_name", with: 'Tester'
         fill_in "client_search_last_name", with: 'Last'
         fill_in "client_search_email", with: 'test@mail.com'
         click_button 'Agregar usuario'
         page.should have_content('Cliente creado')
         page.should_not have_css('#client_search_email')
       end
       
       it "should allow the creation of a new user with the same phone and diferent ext", js: true do
          fill_in "client_search_phone", with: '8095551234'
          fill_in "client_search_ext", with: '100'
          fill_in "client_search_first_name", with: 'tester'
          fill_in "client_search_last_name", with: 'Last'
          fill_in "client_search_email", with: 'test2@mail.com'
          click_button 'Agregar usuario'
          page.should have_content('Cliente creado')
          page.should_not have_css('#client_search_email')
        end

       # this test does not pass when phones are the same
       it "should create clients in sequence", js: true do
         fill_in "client_search_phone", with: '8095551234'
         fill_in "client_search_ext", with: '41'
         fill_in "client_search_first_name", with: 'Tester'
         fill_in "client_search_last_name", with: 'Last'
         fill_in "client_search_email", with: 'test1@mail.com'
         click_button 'Agregar usuario'
         page.should have_content('Cliente creado')
         fill_in "client_search_phone", with: '8095431234'
         fill_in "client_search_ext", with: '42'
         fill_in "client_search_first_name", with: 'iester'
         fill_in "client_search_last_name", with: 'Last'
         fill_in "client_search_email", with: 'test2@mail.com'
         click_button 'Agregar usuario'
         page.should have_content('Cliente creado')
          fill_in "client_search_phone", with: '8095341234'
          fill_in "client_search_ext", with: '43'
          fill_in "client_search_first_name", with: 'iester'
          fill_in "client_search_last_name", with: 'Last'
          fill_in "client_search_email", with: 'test3@mail.com'
          click_button 'Agregar usuario'
         page.should have_content('Cliente creado')
         page.should_not have_css('#client_search_email')
       end
      
      
      describe "when validating" do
        before(:each) do
          @client = FactoryGirl.create(:client, first_name: 'tester')
          @phone = FactoryGirl.create :phone, client: @client, number: '8095551234', ext: '99'
        end
      
        it "should show the validation error for the user", js: true do
           fill_in "client_search_phone", with: '8095551234'
           fill_in "client_search_ext", with: '45'
           fill_in "client_search_first_name", with: ''
           fill_in "client_search_last_name", with: 'Last'
           fill_in "client_search_email", with: 'test@mail.com'
           click_button 'Agregar usuario'
           page.should have_content('en blanco')
         end
                     
               
      end
  end
end