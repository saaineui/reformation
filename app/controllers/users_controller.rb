class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show]
  before_action :find_user_or_redirect, only: [:token_check, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: [:index, :destroy]
  before_action :already_logged_in,     only: [:new, :create]
  
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
      redirect_to token_check_path(@user, email: @user.email)
    else
      render 'new'
    end
  end
  
  def token_check
    @email = params[:email]
    if token_confirmed || invalid_email
      redirect_to root_url 
    else
      render 'token_check'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user
      flash[:notice] = "Your changes have been saved."
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

  # Before filters
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def find_user_or_redirect
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      flash[:danger] = 'That user does not exist.'
      redirect_back fallback_location: root_url 
    end
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def already_logged_in
    if logged_in?
      flash[:danger] = 'You are already logged in.'
      redirect_to current_user
    end
  end
  
  def token_confirmed
    @user.token.eql?(@user.token_confirmation)
  end
  
  def invalid_email
    !@user.email.eql?(@email)
  end
end
