require 'rails_helper'

RSpec.describe Submission, type: :model do
  fixtures :submissions
  
  let(:submission) { submissions(:one) }
  
  it 'is valid with valid attributes' do
    expect(submission).to be_valid
  end
  
  it { should belong_to(:web_form) }
  it { should have_one(:user) }
  it { should have_many(:submissions_entries).dependent(:destroy) }

  context 'prior to creating new or saving changes to' do
    it { should validate_presence_of(:source) } 
    it { should validate_presence_of(:web_form) }
  end
end
