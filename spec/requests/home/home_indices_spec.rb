#encoding: utf-8
require 'spec_helper'

describe "Home::Indices" do
  describe "when visiting the index path" do
    context "when the user is logged" do

      let!(:user) { create(:user, :operator ) }
      let!(:client) { create(:client, first_name: 'tester') }
      let!(:phone) { create :phone, client: client, number: '8095551234', ext: '99' }

      before(:each) do
        login( user )
        visit root_path 
      end

      subject { page } 

      it "should render the main page" do
        should have_content('Clientes')
      end
       
      it "should show the find user by phone form" do
        should have_css('#client_search')
      end
       
      it 'should not allow access to the admin seccion' do
        visit admin_root_path
        should have_content('No tiene permitido el acceso esta sección')
      end
       
      it "should not allow to write in the non phone fields at first" do
        should have_css('#client_search_first_name[readonly=\'readonly\']')
      end

    end
    
    context "When search for a client" do
      let!(:user) { create(:user, :operator) }
      let!(:client) { create(:client, first_name: 'tester') }
      let!(:client2) { create(:client, first_name: 'another') }
      let!(:phone) { create :phone, client: client, number: '8095551234', ext: nil }
      let!(:phone2) { create :phone, client: client2, number: '8095551234', ext: '2' }

      subject { page }

      before do
        login( user )
        visit root_path
      end

      it "should find the users in the list", js: true do
        selector = '.ui-menu-item a:first'
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
        should have_css('#client_search_email')
        should have_css('#add_client_button')
      end
      
      it "should clear the user info if i start typing the extension", js: true do
        selector = '.ui-menu-item  a:first'
        fill_in "client_search_phone", with: '8095551234'
        sleep(1)
        page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
        fill_in "client_search_ext", with: '1'
        find_field('client_search_first_name').value.should == ''
      end
      
      it "should switch back if the user exits with the same number and another extention", js: true do
        selector = '.ui-menu-item  a:first'
        fill_in "client_search_phone", with: '8095551234'
        sleep(1)
        page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
        fill_in "client_search_ext", with: '2'
        find_field('client_search_first_name').value.should == 'another'
      end
    end
     
    context "when assigning a client" do
      let!(:user) { create(:user, :operator) }
      let!(:client) { create(:client, first_name: 'tester') }
      let!(:phone) { create :phone, client: client, number: '8095551234', ext: '99' }

      subject { page }


      before(:each) do
        Capybara.current_driver = :selenium
        login( user )
        visit root_path 
      end
     
      after(:each)do
        Capybara.use_default_driver
      end
     
      it "should present the current client name in the sub nav bar", js: true do
        selector = '.ui-menu-item  a:first'
        fill_in "client_search_phone", with: '8095551234'
        sleep(1)
        page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
        page.find_by_id('client_search_phone').native.send_keys([:return])
        within('.subnav-fixed') { should have_content(client.full_name) }
      end
       
    end
     
    context "when assigning a delivery method" do
      let!(:user) { create :user }

      subject { page }

      before(:each) do
        login( user )
        visit root_path 
      end

       
      it "should assign render the delivery method menu" do
        click_link('choose_service_method')
        should have_css('ul.dropdown-menu:first', visible: true)
      end
       
      it "should set delvery as the service method persistenly", js: true do
        click_link('choose_service_method')
        click_link('service_method_delivery')
        visit root_path
        within('#choose_service_method') { should have_content('delivery') }
      end
       
      it "should set pickup as the service method persistenly", js: true do
        click_link('choose_service_method')
        click_link('service_method_pickup')
        visit root_path
        within('#choose_service_method') { should have_content('pickup') }
      end
        
      it "should set dine in as the service method persistenly", js: true do
        click_link('choose_service_method')
        click_link('service_method_dine_in')
        visit root_path
        within('#choose_service_method') { should have_content('dinein') }
      end
       
    end   
     

    context 'when user is not logged' do

      subject { page }


      it "should redirect_to the login" do
        visit root_path
        should have_content('Debe iniciar sesión para continuar')
        should have_css('#sessions')
      end

    end

  end

end
