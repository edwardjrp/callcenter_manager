#encoding:utf-8
require 'spec_helper'

describe 'Users general' do
  let!(:admin){create :user, :username=>'testadmin', :password=>"please", :password_confirmation=>"please", :roles=>[:admin]}
  let!(:operator){create :user, :username=>'opt', :password=>"please", :password_confirmation=>"please", :roles=>[:operator]}
  let!(:operator2) { create :user , :roles=>[:operator]}
  let!(:cart) { create :cart, user: operator2 , completed: true}

  before do
    login(admin)
    visit admin_users_path
  end

  subject { page }

  context "when logged as an admin" do

    it 'should render the users list with their roles' do
      should have_content(admin.username)
      should have_content(operator.username)
    end


    it 'should render actions link' do
      within("#user_#{admin.id}"){should have_content('Mostrar')}
      within("#user_#{admin.id}"){should have_content('Editar')}
      within("#user_#{admin.id}"){should have_content('Eliminar')}
    end
    

    it "should take to the user show page" do
      within("#user_#{admin.id}"){click_link('Mostrar')}
      should have_content('Información del agente')
      should have_content(admin.roles.to_a.first.to_s)
    end

    it "should take to the user edit page" do
      within("#user_#{admin.id}"){click_link('Editar')}
      should have_css('form.simple_form')
    end

    it "should create a user" do
      click_link('Agregar agente')
      should have_css('form.simple_form')
      fill_in 'Username', with: 'second'
      fill_in 'Nombre', with: 'testname2'
      fill_in 'Apellido', with: 'test2'
      fill_in 'Cedula', with: '00113574334'
      fill_in 'Password', with: 'please'
      fill_in 'Password confirmation', with: 'please'
      choose 'operator'
      check 'Active'
      click_button 'Crear Agente'
      should have_content('Agente creado.')
    end


    it "should validation error for new user" do
      click_link('Agregar agente')
      should have_css('form.simple_form')
      fill_in 'Username', with: ''
      fill_in 'Nombre', with: 'testname2'
      fill_in 'Apellido', with: 'test2'
      fill_in 'Cedula', with: '00113574334'
      choose 'operator'
      check 'Active'
      click_button 'Crear Agente'
      should have_content('no puede')
    end

    it "should edit the user" do
      within("#user_#{operator.id}") { click_link('Editar') }
      fill_in 'Username', with: 'Edited name'
      click_button 'Actualizar Agente'
      should have_content('Agente actualizado.')
    end

    it "should show valdiation error" do
      within("#user_#{operator.id}") { click_link('Editar') }
      fill_in 'Username', with: ''
      click_button 'Actualizar Agente'
      should have_content('no puede')
    end


    it "should delete the user", js: true do
      within("#user_#{operator.id}") { click_link('Eliminar') }
      page.driver.browser.switch_to.alert.accept
      should_not have_content('opt')
      should have_content('Agente eliminado')
    end

    it "should not delete the last administrator", js: true do
      within("#user_#{admin.id}") { click_link('Eliminar') }
      page.driver.browser.switch_to.alert.accept
      should have_content('testadmin')
      should have_content('No puede eliminar al usuario con que inicio sesión')
    end

    it "should not remove the user from the list if it has completed carts", js: true do
      within("#user_#{operator2.id}") { click_link('Eliminar') }
      page.driver.browser.switch_to.alert.accept
      should have_content(operator2.first_name)
      should have_content('Algunas ordenes hacen referencia a este agente')
    end
  end
end