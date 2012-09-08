#encoding:utf-8
require 'spec_helper'

describe 'Settings general' do
  before(:each) do 
    @admin = FactoryGirl.create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]
    @operator = FactoryGirl.create :user, :username=>'test', :password=>"please", :password_confirmation=>"please", :roles=>[:operator]
  end
  
  context "when logged as an admin" do
    before(:each) do
      login(@admin)
      visit admin_settings_path
    end
    it 'should render the settings list' do
      page.should have_content('Configuración')
    end

    it 'should display the node_url' do
      page.should have_content('Servicio Websockets')
    end

    it 'should display the default price store id' do
      page.should have_content('Id tienda de precios')
    end

    it 'should display the default price store ip' do
      page.should have_content('Ip tienda de precios')
    end

    it 'should display the default pulse port' do
      page.should have_content('Puerto de escucha en pulse')
    end
    
    # it 'should save the configuration' do
    #   fill_in 'Servicio Websockets', with: 'localhost:3030'
    #   click_button 'Guardar'
    #   page.should have_content('localhost:3030')
    # end


  end
end