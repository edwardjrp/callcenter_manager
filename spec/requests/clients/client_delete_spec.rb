 #encoding: utf-8
require 'spec_helper'

describe "client delete" do
 describe 'deleting and address', js: true do
    before(:each) do
      Capybara.current_driver = :selenium_chrome
      @user = FactoryGirl.create(:user)
      login(@user)
      @street = FactoryGirl.create :street
      @area = @street.area
      @city = @area.city
      @client = FactoryGirl.create(:client, first_name: 'tester')
      @phone = FactoryGirl.create :phone, client: @client, number: '8095551234', ext: '99'
      @address= FactoryGirl.create :address, street: @street, client: @client
      visit root_path
      selector = '.ui-menu-item  a:first'
      fill_in "client_search_phone", with: '8095551234'
      sleep(1)
      page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
      page.find_by_id('client_search_phone').native.send_keys([:return])
      within('.subnav-fixed'){click_link(@client.full_name)}
    end

    after(:each)do
      Capybara.use_default_driver
    end

    it "should have the address in the list" do
      page.should have_css('#addresses_list')
      page.should have_content(@address.street.name)
      page.should have_css(".client_address[data-address-id='#{@address.id}']")
    end
  end

end