require 'rails_helper'

RSpec.describe 'Sign up and confirm token', type: :request do
  fixtures :users
  let(:user) { users(:normal) }
  let(:password) { 'password' }
  let(:new_user_name) { 'New User Signup' }
  
  context 'homepage' do
    it 'displays sign up and login buttons' do
      get '/'
      assert_select '.container.main-container' do
        assert_select 'a[href="/signup"]', 'Sign Up'
        assert_select 'a[href="/login"]', 'Login'
      end
    end
  end
  
  context 'signup' do
    it 'displays sign up form' do
      get '/signup'
      assert_select 'form#new_user' do
        assert_select 'input[name="user[name]"]', 1
        assert_select 'input[name="user[email]"]', 1
        assert_select 'input[name="user[password]"]', 1
        assert_select 'input[name="user[password_confirmation]"]', 1
        assert_select 'input[type=submit]', 1
      end
    end
    
    it 'rejects incomplete signup and reloads form with errors' do
      post '/users', params: { 
        user: { 
          name:                  new_user_name,
          email:                 '',
          password:              password,
          password_confirmation: 'passwork'
        }
      }
      
      assert_select 'form#new_user' do
        assert_select '.alert.alert-warning', 'Email can\'t be blank'
        assert_select '.alert.alert-warning', 'Email is invalid'
        assert_select '.alert.alert-warning', 'Password confirmation doesn\'t match Password'
      end
    end
    
    it 'signs up user and displays token check form' do
      post '/users', params: { 
        user: { 
          name:                  new_user_name,
          email:                 'user@example.com',
          password:              password,
          password_confirmation: password
        }
      }
      follow_redirect!
      expect(logged_in?).to be(false)
      
      assert_select 'form' do
        assert_select 'input[name="session[email]"]', 1
        assert_select 'input[name="session[password]"]', 1
        assert_select 'input[name="session[token_confirmation]"]', 1
        assert_select 'input[type=submit]', 1
      end
    end
  end
    
  context 'token confirmation' do
    it 'rejects incorrect token and reloads token check page' do
      post '/login', params: { 
        session: { 
          email:                 user.email,
          password:              password,
          token_confirmation:    password * 3
        }
      }
      follow_redirect!
      expect(logged_in?).to be(false)
      
      assert_select 'form' do
        assert_select 'input[name="session[email]"]', 1
        assert_select 'input[name="session[password]"]', 1
        assert_select 'input[name="session[token_confirmation]"]', 1
        assert_select 'input[type=submit]', 1
      end
    end
    
    it 'confirms token, logs in, and displays profile data' do
      post '/login', params: { 
        session: { 
          email:                 user.email,
          password:              password,
          token_confirmation:    user.token
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
end
