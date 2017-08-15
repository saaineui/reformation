require 'rails_helper'

RSpec.describe 'Login and logout', type: :request do
  fixtures :users
  let(:user) { users(:normal) }
  let(:password) { 'password' }
  
  context 'login' do
    it 'displays login form' do
      get '/login'
      assert_select 'form' do
        assert_select 'input[name="session[email]"]', 1
        assert_select 'input[name="session[password]"]', 1
        assert_select 'input[type=submit]', 1
      end
    end
    
    it 'rejects incorrect password and reloads login form with alert' do
      user.update(token_confirmation: user.token)
      post '/login', params: { 
        session: { 
          email:    user.email,
          password: 'passwork'
        }
      }
      expect(logged_in?).to be(false)
      
      assert_select '.alert.alert-warning', 'Invalid email/password combination'
      assert_select 'form' do
        assert_select 'input[name="session[email]"]', 1
        assert_select 'input[name="session[password]"]', 1
        assert_select 'input[type=submit]', 1
      end
    end
    
    it 'logs in valid credentials and displays profile data' do
      user.update(token_confirmation: user.token)
      post '/login', params: { 
        session: { 
          email:    user.email,
          password: password
        }
      }
      follow_redirect!
      expect(logged_in?).to be(true)
      
      assert_select '.container.main-container' do
        assert_select '.page-header', user.name
        assert_select 'td', user.name
        assert_select 'td', user.email
        assert_select 'td', user.token
      end
    end
  end
    
  context 'logout' do
    it 'logs out and displays homepage' do
      sign_in(user)
      follow_redirect!
      expect(logged_in?).to be(true)
      
      delete '/logout'
      follow_redirect!
      expect(logged_in?).to be(false)
      
      assert_select '.container.main-container' do
        assert_select 'a[href="/signup"]', 'Signup'
        assert_select 'a[href="/login"]', 'Login'
      end
    end
  end
end
