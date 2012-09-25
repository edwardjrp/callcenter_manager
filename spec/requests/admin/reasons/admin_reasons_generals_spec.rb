require 'spec_helper'

describe "Admin Reasons Generals" do
  describe " Browsing the list" do
    let!(:reason) { create :reason, description: 'test reason' }
    let!(:cart) { create :cart, reason: reason }
    let!(:admin) { create :user , :admin}

    subject { page }

    before { login(admin) }

    it "should render the link in the subnav" do
      visit admin_clients_path 
      within('.subnav') { should have_content('Razones') }
    end

    it "should take to the reasons list" do
      visit admin_clients_path 
      within('.subnav') { click_link('Razones') }
      within('#reasons_list') { should have_content(reason.description) }
    end

    it "should edit the reason", js: true do
      visit admin_reasons_path 
      find("#best_in_place_reason_#{reason.id}_description").click
      should have_css('.form_in_place')
      within('.form_in_place'){ fill_in 'description', :with => 'Edited description'}
      page.execute_script("$('.form_in_place').find('input:first').trigger('blur')")
      within("#best_in_place_reason_#{reason.id}_description"){ should have_content 'Edited description'}
    end

    it "should show the carts in the reason" do
      visit admin_reasons_path 
      within("#reason_#{reason.id}") { click_link('Ordenes') }
      should have_content(cart.user.full_name)
    end


  end

end
