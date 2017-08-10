require 'rails_helper'

RSpec.describe WebFormsController, type: :controller do
  fixtures :web_forms, :users
  let(:contact_form) { web_forms(:contact) }
  let(:hire_form) { web_forms(:to_hire) }
  let(:user) { users(:normal) }
  NEW_FORM_NAME = 'New Form'.freeze

  describe 'GET #new' do
    context 'when logged out' do
      it 'redirects to login' do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      it 'responds successfully' do
        sign_in(user)
        get :new
        expect(response).to be_success
        expect(response).to render_template('new')
      end
    end
  end

  describe 'POST #create' do
    let(:create_params) { { web_form: { name: NEW_FORM_NAME, user_id: user.id } } } 
    
    context 'when logged out' do
      it 'redirects to login' do
        post :create, params: create_params
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      context 'with valid data' do
        it 'creates form and redirects to form show page' do
          sign_in(user)
          post :create, params: create_params
          web_form = WebForm.find_by_name(NEW_FORM_NAME)
          expect(response).to redirect_to(web_form_path(web_form))
        end
      end
      
      context 'with incomplete data' do
        it 'renders new again with errors' do
          sign_in(user)
          post :create, params: { web_form: { name: '', user_id: user.id } }
          expect(response).to be_success
          expect(response).to render_template('new')
        end
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
        get :show, params: { id: hire_form.id }
        expect(response).to be_success
        expect(response).to render_template('show')
      end

      context 'and resource is not owned' do
        it 'redirects to profile page' do
          sign_in(user)
          get :show, params: { id: contact_form.id }
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when logged out' do
      it 'redirects to login' do
        get :edit, params: { id: hire_form.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      it 'responds successfully with edit template' do
        sign_in(user)
        get :edit, params: { id: hire_form.id }
        expect(response).to be_success
        expect(response).to render_template('edit')
      end

      context 'and resource is not owned' do
        it 'redirects to profile page' do
          sign_in(user)
          get :edit, params: { id: contact_form.id }
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:form_name) { hire_form.name }
    let(:update_params) { { id: hire_form.id, web_form: { name: NEW_FORM_NAME } } }

    context 'when logged out' do
      it 'redirects to login without updating' do
        patch :update, params: update_params
        expect(response).to redirect_to(login_path)

        hire_form.reload
        expect(hire_form.name).to be(form_name)
      end
    end

    context 'when logged in' do
      it 'updates resource and redirects to form show page' do
        sign_in(user)
        patch :update, params: update_params
        expect(response).to redirect_to(web_form_path(hire_form))

        hire_form.reload
        expect(hire_form.name).to eq(NEW_FORM_NAME)
      end

      context 'and resource is not owned' do
        it 'redirects to profile page without updating' do
          sign_in(user)
          patch :update, params: { id: contact_form.id, web_form: { name: NEW_FORM_NAME } }
          expect(response).to redirect_to(user_path(user))

          hire_form.reload
          expect(hire_form.name).to be(form_name)
        end
      end

      context 'and resource is not found' do
        it 'redirects to users index' do
          sign_in(user)
          patch :update, params: { id: -1, web_form: { name: NEW_FORM_NAME } }
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when logged out' do
      it 'redirects to login without deleting' do
        delete :destroy, params: { id: hire_form.id }
        expect(response).to redirect_to(login_path)
        expect(WebForm.find(hire_form.id)).to eq(hire_form)
      end
    end

    context 'when logged in' do
      it 'deletes resource and redirects to profile page' do
        sign_in(user)
        delete :destroy, params: { id: hire_form.id }
        expect(response).to redirect_to(user_path(user))
        expect{ WebForm.find(hire_form.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'and resource is not owned' do
        it 'redirects to profile page without deleting' do
          sign_in(user)
          delete :destroy, params: { id: contact_form.id }
          expect(response).to redirect_to(user_path(user))
          expect(WebForm.find(contact_form.id)).to eq(contact_form)
        end
      end

      context 'and resource is not found' do
        it 'redirects to profile page' do
          sign_in(user)
          delete :destroy, params: { id: -1 }
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
  end
  
  describe 'GET #submissions' do
    context 'when logged out' do
      it 'redirects to login' do
        get :submissions, params: { id: hire_form.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      it 'responds successfully with show template' do
        sign_in(user)
        get :submissions, params: { id: hire_form.id }
        expect(response).to be_success
        expect(response).to render_template('submissions')
      end

      context 'and resource is not owned' do
        it 'redirects to profile page' do
          sign_in(user)
          get :submissions, params: { id: contact_form.id }
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
  end
  
  describe 'GET #embed_code' do
    context 'when logged out' do
      it 'redirects to login' do
        get :embed_code, params: { id: hire_form.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      it 'responds successfully with show template' do
        sign_in(user)
        get :embed_code, params: { id: hire_form.id }
        expect(response).to be_success
        expect(response).to render_template('embed_code')
      end

      context 'and resource is not owned' do
        it 'redirects to profile page' do
          sign_in(user)
          get :embed_code, params: { id: contact_form.id }
          expect(response).to redirect_to(user_path(user))
        end
      end
    end
  end
end
