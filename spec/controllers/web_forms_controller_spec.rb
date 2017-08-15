require 'rails_helper'

RSpec.describe WebFormsController, type: :controller do
  fixtures :submissions, :submissions_entries, :web_forms, :web_form_fields, :users
  let(:contact_form) { web_forms(:contact) }
  let(:hire_form) { web_forms(:to_hire) }
  let(:name_field) { web_form_fields(:to_hire_name) }
  let(:email_field) { web_form_fields(:to_hire_email) }
  let(:user) { users(:normal) }
  let(:new_form_name) { 'New Form' }

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
    let(:create_params) { { web_form: { name: new_form_name, user_id: user.id } } } 
    
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
          web_form = WebForm.find_by_name(new_form_name)
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
    let(:hire_form_name) { hire_form.name }
    let(:contact_form_name) { contact_form.name }
    let(:update_params) do
      { 
        id: hire_form.id, 
        web_form: { 
            name: new_form_name, 
            web_form_fields_attributes: {
              '0' => { name: new_form_name, required: '1', _destroy: '0', id: name_field.id },  
              '1' => { name: email_field.name, required: '1', _destroy: '1', id: email_field.id }
            } 
        } 
      } 
    end

    context 'when logged out' do
      it 'redirects to login without updating' do
        patch :update, params: update_params
        expect(response).to redirect_to(login_path)

        hire_form.reload
        expect(hire_form.name).to eq(hire_form_name)
        expect(WebFormField.find(email_field.id)).to eq(email_field)
      end
    end

    context 'when logged in' do
      it 'updates resource and redirects to form show page' do
        sign_in(user)
        patch :update, params: update_params
        expect(response).to redirect_to(web_form_path(hire_form))

        hire_form.reload
        name_field.reload
        expect(hire_form.name).to eq(new_form_name)
        expect(name_field.name).to eq(new_form_name)
        expect(name_field.required?).to be(true)
        expect { WebFormField.find(email_field.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'and resource is not owned' do
        it 'redirects to profile page without updating' do
          sign_in(user)
          patch :update, params: { id: contact_form.id, web_form: { name: new_form_name } }
          expect(response).to redirect_to(user_path(user))

          contact_form.reload
          expect(contact_form.name).to eq(contact_form_name)
        end
      end

      context 'and resource is not found' do
        it 'redirects to users index' do
          sign_in(user)
          patch :update, params: { id: -1, web_form: { name: new_form_name } }
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
      it 'deletes resource and dependents, and redirects to profile page' do
        sign_in(user)
        delete :destroy, params: { id: hire_form.id }
        expect(response).to redirect_to(user_path(user))
        expect { WebForm.find(hire_form.id) }.to raise_error(ActiveRecord::RecordNotFound)
        
        expect(WebFormField.find_by(web_form: hire_form)).to be(nil)
        expect(Submission.find_by(web_form: hire_form)).to be(nil)
        expect(SubmissionsEntry.all.count).to eq(1)
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
