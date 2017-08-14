require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  CORRECT_PASSWORD = 'password'.freeze
  INCORRECT_PASSWORD = 'notcorrect'.freeze
  
  fixtures :users
  let(:confirmed_user) { users(:admin) }
  let(:unconfirmed_user) { users(:normal) }
  let(:unconfirmed_params) { { session: { email: unconfirmed_user.email, password: CORRECT_PASSWORD } } }
  
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
        sign_in(confirmed_user)
        get :new
        expect(response).to redirect_to(user_path(confirmed_user))
      end
    end
  end

  describe 'POST #create' do
    context 'when logged out' do
      context 'for confirmed account' do
        context 'with valid data' do
          it 'logs in and redirects to profile' do
            post :create, params: { session: { email: confirmed_user.email, password: CORRECT_PASSWORD } }
            expect(response).to redirect_to(user_path(confirmed_user))
          end
        end

        context 'with invalid data' do
          it 'renders new template with errors' do
            post :create, params: { session: { email: confirmed_user.email, password: INCORRECT_PASSWORD } }
            expect(response).to be_success
            expect(response).to render_template('new')
          end
        end
      end

      context 'for unconfirmed account' do
        context 'with valid data' do
          it 'redirects to token check page without logging in' do
            post :create, params: unconfirmed_params
            expect(response).to redirect_to(token_check_path(unconfirmed_user, nickname: unconfirmed_user.nickname))
          end
        end
      end
    end

    context 'when logged in as other user' do
      it 'redirects to profile' do
        sign_in(confirmed_user)
        post :create, params: unconfirmed_params
        expect(response).to redirect_to(user_path(confirmed_user))
      end
    end
  end
end
