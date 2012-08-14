require 'spec_helper'

describe 'Stores general' do
  before(:each)do
    login(FactoryGirl.create :user, :roles=>[:admin])
    @store = FactoryGirl.create :store, :name=>'test store'
    @products = []
    10.times{@products.push FactoryGirl.create :product}
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
  
  
  it "should render the edit link" do
    visit admin_stores_path
    within("#store_#{@store.id}") do 
      page.should have_content('Editar')
    end
  end

  it "should show the edit store section" do
    visit admin_stores_path
    within("#store_#{@store.id}") do 
      click_link('Editar')
    end
    page.should have_css('.simple_form')
  end

  it "should edit the current store name" do
    visit edit_admin_store_path(@store)
    page.should have_css('.simple_form')
    fill_in 'Name', with: 'edited name'
    click_button 'Actualizar Tienda'
    page.should have_css('#stores_list')
    within("#store_#{@store.id}") do 
      page.should have_content('edited name')
    end
    page.should have_content('Tienda actualizada')
  end

  
  context "when showing the products" do
    it "should render the available product for the store" do
      visit admin_stores_path
      within("#store_#{@store.id}"){ click_link 'Productos'}
      within('#products_list'){page.should have_content(@products.first.productname)}
    end
  end
  
end