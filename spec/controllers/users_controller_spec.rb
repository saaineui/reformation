require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  fixtures :users
  let(:admin_user) { users(:admin) }
  let(:user) { users(:normal) }
  NEW_USER_NAME = 'New User'.freeze
  NEW_USER_EMAIL = 'newuser@email.com'.freeze
  PASSWORD = 'password'.freeze
  
  describe 'GET #index' do
    context 'when logged in as admin' do
      it 'responds successfully with index template' do
        sign_in(admin_user)
        get :index
        expect(response).to be_success
        expect(response).to render_template('index')
      end
    end
    
    context 'when logged in as regular user' do
      it 'redirects to root' do
        sign_in(user)
        get :edit, params: { id: admin_user.id }
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'when logged out' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when logged out' do
      it 'responds successfully with new template' do
        get :new
        expect(response).to be_success
        expect(response).to render_template('new')
      end
    end

    context 'when logged in' do
      it 'redirects to profile' do
        sign_in(user)
        get :new
        expect(response).to redirect_to(user_path(user))
      end
    end
  end

  describe 'POST #create' do
    let(:create_params) { { user: { name: NEW_USER_NAME, email: NEW_USER_EMAIL, password: PASSWORD } } } 
    
    context 'when logged out' do
      context 'with valid data' do
        it 'creates user and redirects to profile' do
          post :create, params: create_params
          new_user = User.find_by_name(NEW_USER_NAME)
          expect(response).to redirect_to(token_check_path(new_user, nickname: new_user.nickname))
        end
      end
      
      context 'with incomplete data' do
        it 'renders new template with errors' do
          post :create, params: { user: { name: NEW_USER_NAME, email: NEW_USER_EMAIL, password: '' } }
          expect(response).to be_success
          expect(response).to render_template('new')
        end
      end
    end

    context 'when logged in' do
      it 'redirects to profile without creating user' do
        sign_in(user)
        post :create, params: create_params
        expect(response).to redirect_to(user_path(user))
        expect(User.where(name: NEW_USER_NAME).count).to eq(0)
      end
    end
  end

  describe 'GET #token_check' do
    context 'when token has been confirmed' do
      it 'redirects to root' do
        get :token_check, params: { id: admin_user.id, nickname: admin_user.nickname }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when token has not been confirmed' do
      context 'and valid nickname is provided' do
        it 'responds successfully with token_check template' do
          get :token_check, params: { id: user.id, nickname: user.nickname }
          expect(response).to be_success 
          expect(response).to render_template('token_check')
        end
      end

      context 'and valid nickname is not provided' do
        it 'redirects to root' do
          get :token_check, params: { id: user.id, nickname: '' }
          expect(response).to redirect_to(root_path) 
          
          get :token_check, params: { id: user.id, nickname: admin_user.nickname }
          expect(response).to redirect_to(root_path) 
        end
      end
    end

    context 'when resource is not found' do
      it 'redirects to root' do
        get :token_check, params: { id: -1, nickname: user.nickname }
        expect(response).to redirect_to(root_path) 
      end
    end
  end

  describe 'GET #show' do
    context 'when logged out' do
      it 'redirects to login' do
        get :show, params: { id: user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      it 'responds successfully with show template' do
        sign_in(user)
        get :show, params: { id: user.id }
        expect(response).to be_success
        expect(response).to render_template('show')
      end

      context 'and resource is not owned' do
        it 'redirects to root' do
          sign_in(user)
          get :show, params: { id: admin_user.id }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when logged out' do
      it 'redirects to login' do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      it 'responds successfully with edit template' do
        sign_in(user)
        get :edit, params: { id: user.id }
        expect(response).to be_success
        expect(response).to render_template('edit')
      end

      context 'and resource is not owned' do
        it 'redirects to root' do
          sign_in(user)
          get :edit, params: { id: admin_user.id }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:email) { user.email }
    let(:update_params) { { id: user.id, user: { name: user.name, email: NEW_USER_EMAIL } } }

    context 'when logged out' do
      it 'redirects to login without updating' do
        patch :update, params: update_params
        expect(response).to redirect_to(login_path)

        user.reload
        expect(user.email).to be(email)
      end
    end

    context 'when logged in' do
      it 'updates resource and redirects to profile' do
        sign_in(user)
        patch :update, params: update_params
        expect(response).to redirect_to(user_path(user))

        user.reload
        expect(user.email).to eq(NEW_USER_EMAIL)
      end

      context 'and resource is not owned' do
        it 'redirects to root without updating' do
          sign_in(user)
          patch :update, params: { id: admin_user.id, user: { name: admin_user.name, email: NEW_USER_EMAIL } }
          expect(response).to redirect_to(root_path)

          user.reload
          expect(user.email).to be(email)
        end
      end

      context 'and resource is not found' do
        it 'redirects to users index' do
          sign_in(user)
          patch :update, params: { id: -1, user: { name: NEW_USER_NAME, email: NEW_USER_EMAIL } }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when logged out' do
      it 'redirects to login without deleting user' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(login_path)
        expect(User.find(user.id)).to eq(user)
      end
    end

    context 'when logged in as regular user' do
      it 'redirects to login without deleting' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(login_path)
        expect(User.find(user.id)).to eq(user)
      end
    end

    context 'when logged in as admin' do
      it 'deletes resource and redirects to users index' do
        sign_in(admin_user)
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(users_path)
        expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
      
      context 'and resource is not found' do
        it 'redirects to users index' do
          sign_in(admin_user)
          delete :destroy, params: { id: -1 }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
