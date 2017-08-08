require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  fixtures :users
  
  describe 'GET #index' do
    let(:admin_user) { users(:admin) }
    let(:user) { users(:normal) }

    it 'redirects guest users' do
      get :index
      expect(response).to redirect_to(login_path)
    end

    it 'redirects regular users' do
      sign_in(user)
      get :edit, params: { id: admin_user.id }
      expect(response).to redirect_to(root_path)
    end

    it 'responds successfully to admin users' do
      sign_in(admin_user)
      get :index
      expect(response).to be_success
    end
    
    it 'renders the index template' do
      sign_in(admin_user)
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #new' do
    it 'responds successfully' do
      get :new
      expect(response).to be_success
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    let(:admin_user) { users(:admin) }
    let(:user) { users(:normal) }

    it 'redirects guest users' do
      get :edit, params: { id: 1 }
      expect(response).to redirect_to(login_path)
    end

    it 'responds successfully to regular users' do
      sign_in(user)
      get :edit, params: { id: user.id }
      expect(response).to be_success
    end

    it 'renders the edit template' do
      sign_in(user)
      get :edit, params: { id: user.id }
      expect(response).to render_template('edit')
    end

    it 'redirects regular users from edit pages of other users' do
      sign_in(user)
      get :edit, params: { id: admin_user.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #update' do
    NEW_USER_EMAIL = 'notuser@email.com'.freeze
    let(:admin_user) { users(:admin) }
    let(:user) { users(:normal) }
    let(:email) { user.email }
    let(:update_params) { { id: user.id, user: { name: user.name, email: NEW_USER_EMAIL } } }

    it 'redirects guest users' do
      patch :update, params: update_params
      expect(response).to redirect_to(login_path)
      
      user.reload
      expect(user.email).to be(email)
    end

    it 'updates data and redirects regular users to profile' do
      sign_in(user)
      patch :update, params: update_params
      expect(response).to redirect_to(user_path(user))
      
      user.reload
      expect(user.email).to eq(NEW_USER_EMAIL)
    end

    it 'prevents regular users from patch updating other users' do
      sign_in(user)
      patch :update, params: { id: admin_user.id, user: { name: admin_user.name, email: NEW_USER_EMAIL } }
      expect(response).to redirect_to(root_path)
      
      user.reload
      expect(user.email).to be(email)
    end
  end

  describe 'DELETE #destroy' do
    let(:admin_user) { users(:admin) }
    let(:user) { users(:normal) }

    it 'redirects guest users' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(login_path)
    end

    it 'redirects regular users' do
      user_count = User.all.count
      
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(login_path)
      expect(User.all.count).to eq(user_count)
    end

    it 'responds successfully to admin user' do
      sign_in(admin_user)

      user_count = User.all.count
      
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(users_path)
      expect(User.all.count).to eq(user_count - 1)
    end
  end
end
