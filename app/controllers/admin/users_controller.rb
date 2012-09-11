class Admin::UsersController < ApplicationController
  before_filter {|c| c.accessible_by([:admin], root_path)}
  def index
    @users = User.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success]='Agente creado.'
      redirect_to admin_users_path
    else
      render action: :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success]='Agente actializado.'
      redirect_to admin_users_path
    else
      render action: :edit
    end
  end

  def destroy 
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success]='Agente eliminado.'
    else
      flash[:success]=@user.errors.full_messaged.to_sentence
    end
    redirect_to admin_users_path
  end

  def show
    @user = User.find(params[:id])
    @carts = @user.carts
  end
end