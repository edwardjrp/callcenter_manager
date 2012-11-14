 #encoding: utf-8
require 'spec_helper'

describe "client delete phone and address" do
  
  describe 'when deleting phones and address', js: true do
    let!(:user) { create :user }
    let!(:street) { create :street }
    let!(:area) { street.area }
    let!(:city) { area.city }
    let!(:client) { create(:client, first_name: 'tester') }
    let!(:phone) { create :phone, client: client, number: '8095551234', ext: '99' }
    let!(:phone2) { create :phone, client: client, number: '8095551235', ext: '99' }
    let!(:address) { create :address, street: street, client: client }


    before do
      Capybara.current_driver = :selenium
      login(user)
      visit root_path
      selector = '.ui-menu-item  a:first'
      fill_in "client_search_phone", with: '8095551234'
      sleep(1)
      page.execute_script " $('#{selector}').trigger(\"mouseenter\").click();"
      page.find_by_id('client_search_phone').native.send_keys([:return])
      has_content? '.subnav-fixed'
      within('.subnav-fixed') { click_link(client.full_name) }
    end

    after do
      Capybara.use_default_driver
    end

    it "should have remove the address from the addresses_list" do
      page.should have_css('#addresses_list')
      page.should have_content(address.street.name)
      page.should have_css("#address_#{address.id}")
      within("#address_#{address.id}") do 
        page.should have_css('.icon-trash')
        page.execute_script("$('#utils').hide()")
        find('.icon-trash').click
        page.driver.browser.switch_to.alert.accept
      end
      page.should_not have_css("#address_#{address.id}")
    end

    it "should have remove the phone from the phone_list" do
      page.should have_css('#phones_list')
      page.should have_css("#phone_#{phone2.id}")
      within("#phone_#{phone2.id}") do 
        page.should have_css('.icon-trash')
        page.execute_script("$('#utils').hide()")
        find('.icon-trash').click
        page.driver.browser.switch_to.alert.accept
      end
      page.should_not have_css("#phone_#{phone2.id}")
    end

  end

end