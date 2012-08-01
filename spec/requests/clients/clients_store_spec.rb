#encoding: utf-8
require 'spec_helper'

describe "Client store" do
  describe "when choosing store, target address, and service method" do
      before(:each) do
        # Capybara.current_driver = :selenium_chrome
        login(FactoryGirl.create(:user))
        @street = FactoryGirl.create :street
        @area = @street.area
        @city = @area.city
        @store = FactoryGirl.create :store, city: @city
        @area.store = @store
        @area.save
        @client = FactoryGirl.create(:client, first_name: 'tester')
        @phone = FactoryGirl.create :phone, client: @client, number: '8095551234', ext: '99'
        @address1 = FactoryGirl.create :address, street: @street, client: @client
        @address2 = FactoryGirl.create :address, street: @street, client: @client

        visit root_path 
      end
      
      # after(:each)do
      #    Capybara.use_default_driver
      # end
      
      
      context "when selecting a store" do        
        
        it "should render the stores list" do
          page.should have_css('a#choose_store')
          find('a#choose_store').click
          page.should have_selector('#store_list', visible: true)
        end

        it "should render the stores list", js: true do
          page.should have_css('a#choose_store')
          find('a#choose_store').click
          within('#store_list') do
            find('.set_target_store:first').click
          end
          within('#choose_store'){page.should have_content(@store.name)}
        end
        
      end
      
  end
end