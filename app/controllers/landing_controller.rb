class LandingController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_admin
  
  def home; end

  def share; end

  def leev; end
end
