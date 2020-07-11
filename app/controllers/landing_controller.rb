class LandingController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_admin
  
  def home; end

  def share; end

  def amicus
    @amicus_form = WebForm.where(name: "amicus").first
    
    @names = @amicus_form.submissions.map do |submission| 
      submission.value_for_field(
        WebFormField.where(web_form: @amicus_form, name: 'Name') 
      )
    end
  end
end
