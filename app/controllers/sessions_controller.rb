class SessionsController < ApplicationController
    before_action :logged_in_user, only: [:new]

    def new
    end
    
    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            log_in user
            redirect_back_or user
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
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
        if logged_in?
           flash[:danger] = 'You are already logged in.'
           redirect_to current_user
        end
    end
end