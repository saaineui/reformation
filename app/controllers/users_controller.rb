class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create token_check]
  skip_before_action :require_admin, except: %i[index destroy]
  before_action :find_user_or_redirect, only: %i[token_check show edit update destroy]
  before_action :require_owner, only: %i[edit update show]
  before_action :redirect_if_logged_in, only: %i[new create]
  
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Your account has been created. Welcome #{@user.name} (#{@user.email})."
      redirect_to token_check_path(@user, nickname: @user.nickname)
    else
      render 'new'
    end
  end
  
  def token_check
    if @user.token_confirmed? || invalid_nickname
      redirect_to root_url 
    else
      render 'token_check'
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user
      flash[:notice] = 'Your changes have been saved.'
    else
      render 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "#{@user.name} was deleted."
    else
      flash[:danger] = "#{@user.name} could not be deleted."
    end
    redirect_to users_url
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def invalid_nickname
    !@user.nickname.eql?(params[:nickname])
  end
  
  # before filters
  def find_user_or_redirect
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      flash[:danger] = 'That user does not exist.'
      redirect_back fallback_location: root_url 
    end
  end

  def require_owner
    redirect_to(root_url) unless current_user?(@user)
  end

  def redirect_if_logged_in
    return false unless logged_in?
    flash[:danger] = 'You are already signed up.'
    redirect_to current_user
  end
end
