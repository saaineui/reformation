class WebFormsController < ApplicationController
  skip_before_action :require_admin
  before_action :find_form_or_redirect, except: %i[new create]
  before_action :require_owner, except: %i[new create]
  
  def new
    @web_form = WebForm.new(user: current_user)
    8.times { @web_form.web_form_fields.build }
  end
  
  def create
    @web_form = WebForm.new(web_form_params)

    if @web_form.save
      flash[:notice] = 'Your form has been created.'
      redirect_to @web_form
    else
      render 'new'
    end
  end
  
  def show; end

  def edit
    8.times { @web_form.web_form_fields.build }
  end

  def update
    if @web_form.update_attributes(web_form_params)
      redirect_to @web_form
      flash[:notice] = 'Your changes have been saved.'
    else
      render 'edit'
    end
  end

  def destroy
    if @web_form.destroy
      flash[:notice] = "#{@web_form.name} was deleted."
    else
      flash[:danger] = "#{@web_form.name} could not be deleted."
    end
    redirect_to current_user
  end

  def submissions; end

  def embed_code; end

  private

  def web_form_params
    params.require(:web_form).permit(
      :user_id, 
      :name, 
      web_form_fields_attributes: %i[id name required web_form_id _destroy]
    )
  end

  # Before filters
  def find_form_or_redirect
    if WebForm.exists?(params[:id])
      @web_form = WebForm.find(params[:id])
    else
      flash[:danger] = 'That form could not be found.'
      redirect_to user_path(current_user)
    end
  end

  def require_owner
    return true if current_user?(@web_form.user) || current_user.admin?
    flash[:danger] = 'You do not have permission to do that.'
    redirect_to user_path(current_user) 
  end
end
