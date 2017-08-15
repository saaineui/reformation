require 'rails_helper'

RSpec.describe WebForm, type: :model do
  fixtures :submissions, :submissions_entries, :web_forms, :web_form_fields, :users
  let(:contact_form) { web_forms(:contact) }
  
  it 'is valid with valid attributes' do
    expect(contact_form).to be_valid
  end
  
  it { should belong_to(:user) }
  it { should have_many(:web_form_fields).dependent(:destroy) }
  it { should have_many(:submissions).dependent(:destroy) }

  context 'prior to creating new or saving changes to' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }

    it { should accept_nested_attributes_for(:web_form_fields).allow_destroy(true) }
    
    it '#name_blank? returns true if name attribute is blank' do
      expect(contact_form.send(:name_blank?, { 'name' => '' })).to be(true)
      expect(contact_form.send(:name_blank?, { 'name' => 'A Name' })).to be(false)
      expect(contact_form.send(:name_blank?, { 'required' => true })).to be(true)
    end

    it 'rejects nested web form fields with blank names' do
      contact_form.web_form_fields << WebFormField.new(name: 'Phone', required: true)
      contact_form.web_form_fields << WebFormField.new(name: '', required: true)
      contact_form.save
      contact_form.reload

      expect(contact_form.web_form_fields.map(&:name)).to eq(['Your Name', 'Phone'])
    end
  end
end
