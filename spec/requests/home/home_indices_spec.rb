require 'spec_helper'

describe "Home::Indices" do
  describe "when visiting the index path" do
    it "should render the main page" do
      visit root_path
      page.should have_content('Domino\'s')
    end
  end
end
