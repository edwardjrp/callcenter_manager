require 'spec_helper'

describe 'Stores general' do
  before(:each)do
    login(FactoryGirl.create :user, :roles=>[:admin])
    @store = FactoryGirl.create :store, :name=>'test store'
  end
  
  it "should render the link in the nav" do
    within('.navbar-fixed-top'){page.should have_content('Tiendas')}
  end
  
  it "should render the stores listing" do
    visit admin_stores_path
    page.should have_css('#stores_list')
  end

  it "should render the test store" do
    visit admin_stores_path
    page.should have_content('test store')
  end
  
  
  it "should edit in place", js: true do
    #.form-inplace
    visit admin_stores_path
    within("#store_#{@store.id}") do 
      find('span').click
      page.should have_css('span>form.form_in_place')
    end
  end


  it "should edit the name", js: true do
    visit admin_stores_path
    within("#store_#{@store.id}") do 
      find('span:first').click
      page.execute_script("$('.form_in_place').find('input:first').val('edited store')")
      page.execute_script("$('.form_in_place').find('input:first').trigger('blur')")
      page.should_not have_css('.form_in_place')
      page.should have_content('edited store')
    end
    visit admin_stores_path
    within("#store_#{@store.id}"){ page.should have_content('edited store')}
  end

  
end