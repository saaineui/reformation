require 'rails_helper'

RSpec.describe Submission, type: :model do
  fixtures :submissions, :submissions_entries, :web_forms, :web_form_fields, :users
  
  let(:submission) { submissions(:one) }
  let(:to_hire_name) { web_form_fields(:to_hire_name) }
  
  it 'is valid with valid attributes' do
    expect(submission).to be_valid
  end
  
  it { is_expected.to belong_to(:web_form) }
  it { is_expected.to have_one(:user) }
  it { is_expected.to have_many(:submissions_entries).dependent(:destroy) }

  context 'prior to creating new or saving changes to' do
    it { is_expected.to validate_presence_of(:source) } 
    it { is_expected.to validate_presence_of(:web_form) }
  end
  
  context 'on submissions table' do
    it '#value_for_field finds and displays field value or -' do
      expect(submission.value_for_field(to_hire_name)).to eq('Joe Smith')
      expect(Submission.new.value_for_field(to_hire_name)).to eq('-')
    end
  end
end
