class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :require_admin
  before_action :redirect_if_logged_in, only: %i[new create]

  def new; end

  def create
    if find_and_authenticate_user
      token_confirmation = params[:session][:token_confirmation]
      @user.update(token_confirmation: token_confirmation) if valid_token?(token_confirmation)
      confirm_user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
  
  private
  
  def find_and_authenticate_user
    @user = User.find_by(email: params[:session][:email])
    @user && @user.authenticate(params[:session][:password])
  end
  
  def valid_token?(token_confirmation)
    token_confirmation && token_confirmation.is_a?(String) && token_confirmation.length.eql?(24)
  end
  
  def confirm_user
    if @user.token_confirmed?
      log_in @user
      redirect_to @user
    else
      flash[:notice] = "Welcome #{@user.name} (#{@user.email})."
      redirect_to token_check_path(@user, nickname: @user.nickname)
    end
  end

  # Before filter
  def redirect_if_logged_in
    return false unless logged_in?
    flash[:danger] = 'You are already logged in.'
    redirect_to current_user
  end
end
