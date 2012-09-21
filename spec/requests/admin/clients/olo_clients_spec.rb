# require 'spec_helper'

# describe 'Clients olo' do
#   before(:each)do
#     @user = FactoryGirl.create :user, :roles=>[:admin]
#     login(@user)
#     @client = FactoryGirl.create :client
#     @cart = FactoryGirl.create :cart, :client_id=> @client.id, :user_id=> @user.id
#   end
  
#   it "should render the olo link" do 
#     visit admin_clients_path
#     page.should have_content('Clientes Olo')
#   end

#   it "render the olo clients link", js: true do
#     visit admin_clients_path
#     click_link('Clientes Olo')
#     page.should have_content('Lemuel')
#     page.should have_css('.olo_client')
#   end

#   it "render the back to local clients link", js: true do
#     visit admin_clients_path
#     click_link('Clientes Olo')
#     page.should have_content('Clientes contact center')
#   end

# end