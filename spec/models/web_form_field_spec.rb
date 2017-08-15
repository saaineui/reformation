require 'rails_helper'

RSpec.describe WebFormField, type: :model do
  fixtures :submissions, :submissions_entries, :web_forms, :web_form_fields, :users
  
  let(:field) { web_form_fields(:to_hire_name) }
  let(:required_is_true) { proc { |field| field.required? } }

  it 'is valid with valid attributes' do
    expect(field).to be_valid
  end
  
  it { should belong_to(:web_form) }
  it { should have_many(:submissions_entries) }

  it '#required scope selects required fields' do
    expect(WebFormField.required.count).to eq(2)
    expect(WebFormField.required.all?(&required_is_true)).to be(true)
  end

  context 'prior to creating new or saving changes to' do
    it { should validate_presence_of(:name) }
  end
end
