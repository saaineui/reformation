class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :require_login
  before_action :require_admin
  
  private
  
  # Before filters
  def require_login 
    return true if logged_in?
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
  
  def require_admin 
    return true if current_user.admin?
    flash[:danger] = 'You do not have permission to do that.'
    redirect_back fallback_location: root_url 
  end
end
