class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :require_admin

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if params[:session][:token_confirmation]
        user.token_confirmation = params[:session][:token_confirmation]
        user.save
      end

      if user.token == user.token_confirmation
        log_in user
        redirect_to user
      else
        flash[:notice] = "Welcome #{user.name} (#{user.email})."
        redirect_to token_check_path(user, email: user.email)
      end
    else
     flash.now[:danger] = 'Invalid email/password combination'
     render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
