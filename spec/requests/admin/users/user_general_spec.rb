#encoding:utf-8
require 'spec_helper'

describe 'Users general' do
  let!(:admin){create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]}
  let!(:operator){create :user, :username=>'test', :password=>"please", :password_confirmation=>"please", :roles=>[:operator]}

  context "when logged as an admin" do
    before(:each) do
      login(admin)
      visit admin_users_path
    end

    it 'should render the users list with their roles' do
      page.should have_content(admin.username)
      page.should have_content(operator.username)
    end


    it 'should render actions link' do
      within("#user_#{admin.id}"){page.should have_content('Mostrar')}
      within("#user_#{admin.id}"){page.should have_content('Editar')}
      within("#user_#{admin.id}"){page.should have_content('Eliminar')}
    end
    

    it "should take to the user show page" do
      within("#user_#{admin.id}"){click_link('Mostrar')}
      page.should have_content('Información del agente')
      page.should have_content(admin.roles.to_a.first.to_s)
    end

    it "should take to the user edit page" do
      within("#user_#{admin.id}"){click_link('Editar')}
      page.should have_css('form.simple_form')
    end
  end
end