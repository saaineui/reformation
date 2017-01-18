class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: [:index, :destroy]
  
  def index
      @users = User.all
  end

  def new
      @user = User.new
  end
  
  def create
      @user = User.new(user_params)
      if @user.save
          log_in @user
          flash[:success] = "Your account has been created. Welcome to Reformation."
          redirect_to @user
      else
          render 'new'
      end
  end
  
  def show
      @user = User.find(params[:id])
  end

  def edit
      @user = User.find(params[:id])
  end

  def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
          redirect_to @user
          flash[:success] = "Your changes have been saved."
      else
        render 'edit'
      end
  end

  def destroy
      @user = User.find(params[:id])
      if @user.destroy
          flash[:success] = "#{@user.name} was deleted."
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

    # Confirms a logged-in user.
    def logged_in_user
        unless logged_in?
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
        end
    end

    # Confirms the correct user.
    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
        redirect_to(root_url) unless current_user.admin?
    end

end
