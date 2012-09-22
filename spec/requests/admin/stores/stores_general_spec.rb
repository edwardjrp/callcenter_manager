require 'spec_helper'

describe 'Stores general' do
  before(:each)do
    login(FactoryGirl.create :user, :roles=>[:admin])
    @store = FactoryGirl.create :store, :name=>'test store'
    @products = []
    10.times{@products.push FactoryGirl.create :product}
  end
  
  it "should render the link in the nav" do
    within('.navbar-fixed-top'){page.should have_content('Productos')}
  end
  
  it "should render the stores listing" do
    visit admin_stores_path
    page.should have_css('#stores_list')
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
    within('.simple_form'){find('.btn').click}
    page.should have_css('#stores_list')
    within("#store_#{@store.id}") do 
      page.should have_content('edited name')
    end
    page.should have_content('Tienda actualizada')
  end

  it "should render the add store link" do
    visit admin_stores_path
    page.should have_content('Agregar Tienda')
  end

  it "should render the add store form" do
    visit admin_stores_path
    page.should click_link('Agregar Tienda')
    page.should have_css('.simple_form')
  end

  it "should create a new store" do
    visit new_admin_store_path
    fill_in 'Name', with: 'Test store'
    fill_in 'Address', with: 'Test address'
    fill_in 'Ip', with: '127.0.0.1'
    select @store.city.name, :from =>'store_city_id'
    fill_in 'Storeid', with: '15871'
    within('.simple_form'){find('.btn').click}
    page.should have_css('#stores_list')
    page.should have_content('Test store')
    page.should have_content("Tienda creada")
  end

  it "should show the delete store link" do
    visit admin_stores_path
    within("#store_#{@store.id}") do 
      page.should have_content('Eliminar')
    end
  end

  it "should the delete store", js: true do
    visit admin_stores_path
    name = @store.name
    within("#store_#{@store.id}") do 
      click_link('Eliminar')
    end
    page.should_not have_content(name)
    page.should have_content('Tienda eliminada')
  end

  
  context "when showing the products" do
    it "should render the available product for the store" do
      visit admin_stores_path
      within("#store_#{@store.id}"){ click_link 'Productos'}
      within('#products_list'){page.should have_content(@products.first.productname)}
    end
  end
  
end