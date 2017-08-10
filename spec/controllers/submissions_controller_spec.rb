require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  fixtures :submissions, :web_forms, :users
  let(:owned) { submissions(:one) }
  let(:not_owned) { submissions(:two) }
  let(:hire_form) { web_forms(:to_hire) }
  let(:user) { users(:normal) }

  describe 'DELETE #destroy' do
    context 'when logged out' do
      it 'redirects to login without deleting' do
        delete :destroy, params: { id: owned.id }
        expect(response).to redirect_to(login_path)
        expect(Submission.find(owned.id)).to eq(owned)
      end
    end

    context 'when logged in' do
      it 'deletes resource and dependents and redirects to profile page' do
        sign_in(user)
        delete :destroy, params: { id: owned.id }
        expect(response).to redirect_to(submissions_path(hire_form))
        expect{ Submission.find(owned.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(SubmissionsEntry.where(submission_id: owned.id).count).to eq(0)
      end

      context 'and resource is not owned' do
        it 'redirects to profile page without deleting' do
          sign_in(user)
          delete :destroy, params: { id: not_owned.id }
          expect(response).to redirect_to(user_path(user))
          expect(Submission.find(not_owned.id)).to eq(not_owned)
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
end
