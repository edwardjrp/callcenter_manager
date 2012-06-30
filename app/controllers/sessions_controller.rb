#encoding: utf-8
class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user.present?
      session[:user_token]=user.auth_token
      flash[:success]="Sesión iniciada"
      redirect_to root_path
    else
      flash[:alert]='Usuario o contraseña incorrectos'
      render :action=>:new
    end
  end
  
  def destroy
    session[:user_token]=nil
    flash[:success]="Sesión terminada"
    redirect_to login_path
  end
  
  private
    def authenticate
    end
end
