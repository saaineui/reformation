class SubmissionsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
    
    def destroy
      @submission = Submission.find(params[:id])
      @submission.submissions_entries.each do |entry|
          entry.delete
      end

      if @submission.destroy
          flash[:notice] = "1 #{@submission.web_form.name} submission was deleted."
      else
          flash[:danger] = "#{@submission.web_form.name} submission could not be deleted."
      end
      redirect_to submissions_path(@submission.web_form)
    end

  private
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
        @user = Submission.find(params[:id]).user
        unless current_user?(@user)
            flash[:danger] = "You do not have permission to do that."
            redirect_to(@user) 
        end
    end

end