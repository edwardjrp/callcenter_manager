class AdminConstraint
  def matches?(request)
    return false unless request.session[:user_token]
    user = User.find_by_auth_token request.session[:user_token]
    user && user.is?(:admin)
  end
end