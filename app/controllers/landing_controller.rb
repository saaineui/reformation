class LandingController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_admin

  def home; end

  def share; end

  def amicus
    if amicus_form_missing || invalid_password
      redirect_to root_url
    end
      
    amicus_form = WebForm.where(name: "amicus").first
    
    @submissions = amicus_form.submissions.sort_by(&:id).reverse.map.with_index do |submission, index| 
      {
        name: submission.value_for_field(
          WebFormField.where(web_form: amicus_form, name: 'Name') 
        ),
        tweet: submission.value_for_field(
          WebFormField.where(web_form: amicus_form, name: 'Tweet') 
        ),
        image: submission.value_for_field(
          WebFormField.where(web_form: amicus_form, name: 'Image') 
        ),
        message: submission.value_for_field(
          WebFormField.where(web_form: amicus_form, name: 'Message') 
        ),
        video: submission.value_for_field(
          WebFormField.where(web_form: amicus_form, name: 'Video') 
        ),
      }
    end
  end
end

private

def amicus_form_missing
  WebForm.where(name: "amicus").count == 0
end

def invalid_password
  Rails.application.secrets.amicus_password != params[:password]
end
