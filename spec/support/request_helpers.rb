module RequestHelpers
  def sign_in(user, password = 'password')
    user.update(token_confirmation: user.token) unless user.token_confirmed?
    
    post login_path, params: {
      session: { email: user.email, password: password }
    }
  end
  
  def logged_in?
    !session[:user_id].nil?
  end
end
