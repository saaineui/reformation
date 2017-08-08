module ControllerHelpers
  def sign_in(user = double('user'))
    session[:user_id] = user.id
  end
end
