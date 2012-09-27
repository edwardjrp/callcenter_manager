#encoding: utf-8
require 'spec_helper'

describe "Client store" do

  describe "when choosing store, target address, and service method" do

    let!(:user) { create(:user) }
    let!(:street) { create :street }
    let!(:area) { street.area }
    let!(:city) { area.city }
    let!(:store) { create :store, city: city }
    let!(:client) { create(:client, first_name: 'tester') }
    let!(:phone) { create :phone, client: client, number: '8095551234', ext: '99' }
    let!(:address1) { create :address, street: street, client: client }
    let!(:address2) { create :address, street: street, client: client }

    before(:each) do
      area.store = store
      area.save
      login( user )
      visit root_path 
    end

    subject { page }
      
      
    context "when selecting a store" do        
      
      it "should render the stores list" do
        should have_css('a#choose_store')
        find('a#choose_store').click
        should have_selector('#store_list', visible: true)
      end

      it "should render the stores list", js: true do
        page.should have_css('a#choose_store')
        find('a#choose_store').click
        within('#store_list') do
          find('.set_target_store:first').click
        end
        within('#choose_store') { should have_content(store.name) }
      end
      
    end
      
  end

end