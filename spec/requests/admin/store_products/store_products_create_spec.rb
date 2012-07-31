require 'spec_helper'

describe 'Stores general' do
  before(:each)do
    login(FactoryGirl.create :user, :roles=>[:admin])
    @store = FactoryGirl.create :store, :name=>'test store'
    @products = []
    10.times{@products.push FactoryGirl.create :product}
    @product = @products.first
    visit admin_stores_path
    within("#store_#{@store.id}"){ click_link 'Productos'}
  end



  context "when the asign link in the products listing" do
     it "should render the asing link for the product of the current store" do
       within("#product_#{@product.id}"){page.should have_content('Asignar')}
     end
     
     it "should render the asing link for the product of the current store" , js: true do
       within("#product_#{@product.id}") do
         click_link('Asignar')
         page.should have_content('false')
       end
     end
     
   end

end