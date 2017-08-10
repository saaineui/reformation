require 'rails_helper'

RSpec.describe Api::SubmissionsEntriesController, type: :controller do
  fixtures :web_forms, :web_form_fields
  let(:hire_form) { web_forms(:to_hire) }
  let(:name_field) { web_form_fields(:to_hire_name) }
  let(:email_field) { web_form_fields(:to_hire_email) }
  
  describe 'GET #create' do
    # Submissions
    let(:valid_submission) { 
      { 
        'token' => 'G4JsokU2slUr7SkK93nVMg', 'id' => hire_form.id, 'source' => 'http://valid.io', 
        "web_form_field_#{name_field.id}" => 'Jerry James', "web_form_field_#{email_field.id}" => 'jj@j.com' 
      } 
    }
    let(:unauthorized) { 
      { 
        'id' => hire_form.id, 'source' => 'http://unauthorized.io', 
        "web_form_field_#{name_field.id}" => 'No Token', "web_form_field_#{email_field.id}" => 'no@token.com' 
      } 
    }
    let(:spare_submission) { 
      { 
        'token' => 'G4JsokU2slUr7SkK93nVMg', 'id' => hire_form.id, 'source' => 'http://spare.io', 
        "web_form_field_#{name_field.id}" => '', "web_form_field_#{email_field.id}" => 'noname@gmail.com' 
      } 
    } 
    let(:missing_source) { 
      { 
        'token' => 'G4JsokU2slUr7SkK93nVMg', 'id' => hire_form.id, 'source' => '', 
        "web_form_field_#{name_field.id}" => 'Source Less', "web_form_field_#{email_field.id}" => 'nosource@gmail.com' 
      } 
    } 
    let(:incomplete_submission) { 
      { 
        'token' => 'G4JsokU2slUr7SkK93nVMg', 'id' => hire_form.id, 'source' => 'http://incomplete.io', 
        "web_form_field_#{name_field.id}" => ' || 1; pg_sleep(1);' 
      } 
    } 
    let(:excess_submission) { 
      { 
        'token' => 'G4JsokU2slUr7SkK93nVMg', 'id' => hire_form.id, 'source' => 'http://excess.io', 
        "web_form_field_#{name_field.id}" => 'Lane Kim', "web_form_field_#{email_field.id}" => 'lane@lukesdiner.com', 
        'web_form_field_3' => 'Not a field' 
      } 
    }
    
    # Responses
    let(:success_json) { { 'code' => 200, 'notice' => 'Thanks for your message!' } }
    let(:failure_json) { { 'code' => 404, 'notice' => 'You were missing the following required fields: Email.' } }
    let(:missing_source_json) { { 'code' => 404, 'notice' => 'Your form was missing a source.' } }
    
    context 'with valid data' do
      it 'creates submission and renders json confirmation' do
        get :create, params: valid_submission
        expect(response).to be_success
        expect(JSON.parse(response.body)).to eq(success_json)
        expect(Submission.where(source: 'http://valid.io').count).to eq(1)
        
        submission = Submission.find_by_source('http://valid.io')
        expect(submission.submissions_entries.count).to eq(2)
        expect(submission.submissions_entries.order(:value).map(&:value)).to eq(['Jerry James', 'jj@j.com'])
      end

      context 'without source' do
        it 'renders json error message without creating submission' do
          get :create, params: missing_source
          expect(response).to be_success
          expect(JSON.parse(response.body)).to eq(missing_source_json)

          expect(Submission.where(source: '').count).to eq(0)
        end
      end

      context 'without token' do
        it 'responds with unauthorized' do
          get :create, params: unauthorized
          expect(response).to be_unauthorized
          expect(Submission.where(source: 'http://unauthorized.io').count).to eq(0)
        end
      end
    end

    context 'with only required fields completed' do
      it 'creates submission and renders json confirmation' do
        get :create, params: spare_submission
        expect(response).to be_success
        expect(JSON.parse(response.body)).to eq(success_json)
        expect(Submission.where(source: 'http://spare.io').count).to eq(1)
        
        submission = Submission.find_by_source('http://spare.io')
        expect(submission.submissions_entries.count).to eq(2)
        expect(submission.submissions_entries.order(:value).map(&:value)).to eq(['', 'noname@gmail.com'])
      end
    end

    context 'with incomplete data' do
      it 'renders json error message without creating submission' do
        get :create, params: incomplete_submission
        expect(response).to be_success
        expect(JSON.parse(response.body)).to eq(failure_json)
        
        expect(Submission.where(source: 'http://incomplete.io').count).to eq(0)
      end
    end

    context 'with extra fields completed' do
      it 'creates submission and renders json confirmation' do
        get :create, params: excess_submission
        expect(response).to be_success
        expect(JSON.parse(response.body)).to eq(success_json)
        expect(Submission.where(source: 'http://excess.io').count).to eq(1)
        
        submission = Submission.find_by_source('http://excess.io')
        expect(submission.submissions_entries.count).to eq(2)
        expect(submission.submissions_entries.order(:value).map(&:value)).to eq(['Lane Kim', 'lane@lukesdiner.com'])
      end
    end
  end
end
