class SubmissionsController < ApplicationController
  skip_before_action :require_admin
  before_action :find_submission_or_redirect
  before_action :require_owner
    
  def destroy
    if @submission.destroy
      flash[:notice] = "1 #{@submission.web_form.name} submission was deleted."
    else
      flash[:danger] = "#{@submission.web_form.name} submission could not be deleted."
    end
    redirect_to submissions_path(@submission.web_form)
  end

  private

  # Before filters
  def find_submission_or_redirect
    if Submission.exists?(params[:id])
      @submission = Submission.find(params[:id])
    else
      flash[:danger] = 'That submission does not exist.'
      redirect_to current_user
    end
  end

  def require_owner
    return false if current_user?(@submission.user)
    flash[:danger] = 'You do not have permission to do that.'
    redirect_to current_user
  end
end
