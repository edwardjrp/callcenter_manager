require 'spec_helper'

describe "Admin Tad Ids Generals" do
  describe " Browsing the list" do
    let!(:tax_id) { create :taxpayer_identification, idnumber: '9999999' }
    let!(:admin) { create :user , :admin}

    subject { page }

    before { login(admin) }

    it "should render the link in the subnav" do
      visit admin_clients_path 
      within('.subnav') { should have_content('Numeros Fiscales') }
    end

    it "should take to the tax_id list" do
      visit admin_clients_path 
      within('.subnav') { click_link('Numeros Fiscales') }
      within('#tax_ids_list') { should have_content(tax_id.idnumber) }
    end

  end

end
