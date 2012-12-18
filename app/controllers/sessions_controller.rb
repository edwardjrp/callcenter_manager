#encoding: utf-8
class SessionsController < ApplicationController
  before_filter :redirect_logged_user, only: [:create, :new]
  skip_before_filter :authenticate


  def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user.present?
      session[:user_token]= user.auth_token
      user.login_count += 1
      user.save
      flash[:success]="Sesión iniciada"
      if user.is? [:admin, :supervisor]
        redirect_to admin_root_path
      else
        redirect_to root_path
      end
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
    def redirect_logged_user
      redirect_to root_path if user_signed_in?
    end
end
