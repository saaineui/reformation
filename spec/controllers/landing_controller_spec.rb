require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  fixtures :users
  let(:admin_user) { users(:admin) }
  let(:user) { users(:normal) }

  describe 'GET #home' do
    context 'when logged in as admin' do
      it 'responds successfully with home template' do
        sign_in(admin_user)
        get :home
        expect(response.status).to eq(200) 
        expect(response).to render_template('home')
      end
    end
    
    context 'when logged in as regular user' do
      it 'responds successfully with home template' do
        sign_in(user)
        get :home
        expect(response.status).to eq(200) 
        expect(response).to render_template('home')
      end
    end
    
    context 'when logged out' do
      it 'responds successfully with home template' do
        get :home
        expect(response.status).to eq(200) 
        expect(response).to render_template('home')
      end
    end
  end
end
