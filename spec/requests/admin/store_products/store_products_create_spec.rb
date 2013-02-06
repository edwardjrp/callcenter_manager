require 'spec_helper'

describe 'Stores general' do
  let!(:store) { create :store, :name=>'test store' }
  let!(:products) { create_list :product, 10}
  let!(:product) { products.first }

  before do
    login(create :user, :admin)
    visit admin_stores_path
    within("#store_#{store.id}"){ click_link 'Productos' }
  end

  subject { page }

  context "when the asign link in the products listing" do
     it "should render the asing link for the product of the current store" do
       within("#product_#{product.id}"){ page.should have_content('Asignar') }
     end
     
     it "should render the asing link for the product of the current store" , js: true do
       within("#product_#{product.id}") do
         click_link('Asignar')
         should have_content('false')
         click_link 'false'
         page.should have_content('true')
       end
     end
     
   end

end