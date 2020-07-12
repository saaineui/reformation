class LandingController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_admin

  def home; end

  def share; end

  def amicus
    if WebForm.where(name: "amicus").count == 0 
      return
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
      }
    end
  end
end
