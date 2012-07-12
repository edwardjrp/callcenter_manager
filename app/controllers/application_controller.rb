#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  
  
  protected 
    def accessible_by(roles, fallback_path)
       if user_signed_in?
         unless current_user.has_role? roles
           flash[:alert] = 'No tiene permitido el acceso esta sección'
           redirect_to fallback_path 
         end
       end
     end
  
  
  private
   def authenticate
     if current_user.nil?
       flash[:alert]='Debe iniciar sesión para continuar'
       redirect_to login_path
     end
   end
   
   def current_cart
     if user_signed_in?
       if  session[:current_cart_id] && current_user.carts.exists?(session[:current_cart_id])
          cart =  current_user.carts.find(session[:current_cart_id])
       else
          cart = current_user.carts.create
          session[:current_cart_id] = cart.id
       end
       return cart
     end
   end
   helper_method :current_cart
   
   
   
   def current_user
     return nil unless session[:user_token] || !User.exists?(auth_token: session[:user_token])
     return User.find_by_auth_token(session[:user_token]) 
   end
   helper_method :current_user
   
   def user_signed_in?
     !!current_user.present?
   end
   helper_method :user_signed_in?
end
