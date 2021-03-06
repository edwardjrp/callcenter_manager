#encoding:utf-8
require 'spec_helper'

describe 'Categories general' do
  
  let!(:category) { create :category, :name=>'test category'}

  let!(:user) { create :user, :admin  }

  before { login(user) } 
  
  it "should render de link in the main nav" do
    visit admin_stores_path
    within('.subnav-fixed') { page.should have_content('Categorías') }
  end
  
  it "should display the categories template" do
    visit admin_categories_path
    page.should have_css('#categories')
  end
  
  it "should display the categories list" do
    visit admin_categories_path
    within('#categories_list') { page.should have_content('test category') }
  end
  
  
  describe "changing states", js: true do
    [['change_state_option', 'has_options'], ['change_state_unit','type_unit'],['change_state_multi','multi'], ['change_state_hidden','hidden'], ['change_state_sides','has_sides']].each do |field|
      it "should change the state of #{field[1]}" do
        visit admin_categories_path
        within("#category_#{category.id}") do
          page.should have_css(".#{field[0]}:first", :content=>'false')
          find(".#{field[0]}:first").click
          page.should have_css(".#{field[0]}:first", :content=>'true')
        end
      end
    end
  end
end