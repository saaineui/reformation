class WebFormsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy, :submissions]
  
  def new
      @web_form = WebForm.new()
  end
  
  def create
      @web_form = WebForm.new(web_form_params)
      
      if @web_form.save
          flash[:notice] = "Your form has been created."
          redirect_to @web_form
      else
          render 'new'
      end
  end
  
  def show
      @web_form = WebForm.find(params[:id])
  end

  def edit
      @web_form = WebForm.find(params[:id])
      8.times { @web_form.web_form_fields.build }
  end

  def update
      @web_form = WebForm.find(params[:id])

      if @web_form.update_attributes(web_form_params)
          redirect_to @web_form
          flash[:notice] = "Your changes have been saved."
      else
          render 'edit'
      end
  end

  def destroy
      @web_form = WebForm.find(params[:id])
      if @web_form.destroy
          flash[:notice] = "#{@web_form.name} was deleted."
      else
          flash[:danger] = "#{@web_form.name} could not be deleted."
      end
      redirect_to current_user
  end

  def submissions
      @web_form = WebForm.find(params[:id])
      @col_class = ""
  end

  private
    def web_form_params
        params.require(:web_form).permit(:user_id, :name, web_form_fields_attributes: [:id, :name, :required, :web_form_id, :_destroy])
    end

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
        @user = User.find(WebForm.find(params[:id]).user_id)
        redirect_to(root_url) unless current_user?(@user)
    end

end
