require 'rails_helper'

RSpec.describe SubmissionsEntry, type: :model do
  fixtures :submissions, :submissions_entries, :web_forms, :web_form_fields, :users
  let(:required_entry) { submissions_entries(:to_hire_email_one) }
  let(:not_required_entry) { submissions_entries(:to_hire_name_one) }
  
  it 'is valid with valid attributes' do
    expect(required_entry).to be_valid
  end
  
  it { should belong_to(:submission) }
  it { should belong_to(:web_form_field) }
  it { should delegate_method(:required?).to(:web_form_field) }
  
  it '#required? returns true if web form field is required' do
    expect(required_entry.required?).to be(true)
    expect(not_required_entry.required?).to be(false)
  end

  context 'prior to creating new or saving changes to' do
    it { should validate_presence_of(:submission) } 
    it { should validate_presence_of(:web_form_field) }
    
    context 'field is required' do
      before { allow(subject).to receive(:required?).and_return(true) }
      it { is_expected.to validate_presence_of(:value) }
    end
    
    context 'field is not required' do
      before { allow(subject).to receive(:required?).and_return(false) }
      it { is_expected.not_to validate_presence_of(:value) }
    end
  end
end
