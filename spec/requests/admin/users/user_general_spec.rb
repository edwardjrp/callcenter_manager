#encoding:utf-8
require 'spec_helper'

describe 'Users general' do
  let!(:admin){create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]}
  let!(:operator){create :user, :username=>'opt', :password=>"please", :password_confirmation=>"please", :roles=>[:operator]}

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

    it "should create a user" do
      click_link('Agregar agente')
      page.should have_css('form.simple_form')
      fill_in 'Username', with: 'second'
      fill_in 'Nombre', with: 'testname2'
      fill_in 'Apellido', with: 'test2'
      fill_in 'Cedula', with: '00113574334'
      fill_in 'Password', with: 'please'
      fill_in 'Password confirmation', with: 'please'
      choose 'operator'
      check 'Active'
      click_button 'Crear Agente'
      page.should have_content('Agente creado.')
    end


    it "should validation error for new user" do
      click_link('Agregar agente')
      page.should have_css('form.simple_form')
      fill_in 'Username', with: ''
      fill_in 'Nombre', with: 'testname2'
      fill_in 'Apellido', with: 'test2'
      fill_in 'Cedula', with: '00113574334'
      choose 'operator'
      check 'Active'
      click_button 'Crear Agente'
      page.should have_content('no puede')
    end

    it "should edit the user" do
      within("#user_#{operator.id}"){click_link('Editar')}
      fill_in 'Username', with: 'Edited name'
      click_button 'Actualizar Agente'
      page.should have_content('Agente actializado.')
    end

    it "should show valdiation error" do
      within("#user_#{operator.id}"){click_link('Editar')}
      fill_in 'Username', with: ''
      click_button 'Actualizar Agente'
      page.should have_content('no puede')
    end


    it "should delete the user", js: true do
      within("#user_#{operator.id}"){click_link('Eliminar')}
      page.should_not have_content('opt')
      page.should have_content('Agente eliminado')
    end
  end
end