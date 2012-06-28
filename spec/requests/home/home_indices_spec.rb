#encoding: utf-8
require 'spec_helper'

describe "Home::Indices" do
  describe "when visiting the index path" do
    context "when the user is logged" do
      before(:each) do
        login(FactoryGirl.create(:user))
        @client = FactoryGirl.create(:client, first_name: 'tester')
        @phone = FactoryGirl.create :phone, client: @client, number: '8095551234', ext: '99'
        # 10.times{FactoryGirl.create(:client)}
        visit root_path 
      end
      it "should render the main page" do
        page.should have_content('Clientes')
      end
       
       it "should show the find user by phone form" do
         page.should have_css('#client_search')
       end
       
    end
    
    context "When search for a client" do
       before(:each)do
         Capybara.current_driver = :selenium_chrome
         login(FactoryGirl.create(:user))
         @client = FactoryGirl.create(:client, first_name: 'tester')
         @phone = FactoryGirl.create :phone, client: @client, number: '8095551234', ext: nil
         # 10.times{FactoryGirl.create(:client)}
         visit root_path
       end

       after(:each)do
         Capybara.use_default_driver
       end
       it "should find the users in the list", js: true do
         selector = '.ui-menu-item  a:first'
         fill_in "client_search_phone", with: '8095551234'
         sleep(1)
         page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
         find_field('client_search_first_name').value.should == 'tester'
       end
       
       
       it "should forbid letters on the phone search field", js: true do
          fill_in "client_search_phone", with: 'asd'
          find_field('client_search_phone').value.should == ''
        end
        
        it "should forbid spaces on the phone search field", js: true do
          fill_in "client_search_phone", with: ' '
          find_field('client_search_phone').value.should == ''
        end
        
        it "should show the add user buttons", js: true do
          fill_in "client_search_phone", with: '8095551235'
          page.should have_css('#add_user_button')
        end
     end
    
    context 'when user is not logged' do
      it "should redirect_to the login" do
        visit root_path
        page.should have_content('Debe iniciar sesión para continuar')
        page.should have_css('#sessions')
      end
    end
  end
end
