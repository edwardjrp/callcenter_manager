#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  
  private
   def authenticate
     if current_user.nil?
       flash[:alert]='Debe iniciar sesión para continuar'
       redirect_to login_path
     end
   end
   
   def current_user
     return nil unless session[:user_token] || !User.exists?(auth_token: session[:user_token])
     return User.find_by_auth_token(session[:user_token]) 
   end
   helper_method :current_user
   
end
