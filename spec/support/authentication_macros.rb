module AuthenticationMacros
  def login(user)
    visit login_path
    fill_in 'username', :with => user.username
    fill_in 'password', :with => 'please'
    click_button 'Enviar'
  end
end