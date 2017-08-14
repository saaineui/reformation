require 'rails_helper'

RSpec.describe User, type: :model do
  FAKE_PASSWORD = 'foobarbar'.freeze

  fixtures :users
  
  let(:user) { users(:normal) }
  let(:admin_user) { users(:admin) }
  let(:new_user) { User.create(name: 'Jane Doe', email: 'JANE@DOE.COM', password: FAKE_PASSWORD) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end
  
  it { should have_many(:web_forms).dependent(:destroy) }

  context 'prior to creating new' do
    it '::new_token creates 24 character token' do
      expect(new_user.token.class).to eq(String)
      expect(new_user.token.length).to eq(24)
    end
  end
  
  context 'prior to creating new or saving changes to' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_length_of(:email).is_at_most(50) }
    it { should allow_values('wacky-email.mail@wacky.co.uk', 'other__-_@ok.gov').for(:email) }
    it { should_not allow_values('iamabotemail', 'http://goo.com', 'gmail.com@not').for(:email) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should have_secure_password }
    it { should validate_confirmation_of(:password).on(:create) }

    it '::digest converts password string to valid BCrypt::Password' do
      new_user_digest = User.digest(FAKE_PASSWORD)
      
      expect(new_user_digest.class).to eq(BCrypt::Password)
      expect(new_user_digest.length).to eq(60)
      expect(new_user_digest == FAKE_PASSWORD).to be(true)
    end
    
    it '#normalize_email downcases email address' do
      expect(new_user.email).to eq('jane@doe.com')
      
      user.update(email: 'NORMAL@GMAIL.COM')
      user.reload
      expect(user.email).to eq('normal@gmail.com')
    end
  end
  
  context 'during token check step of login process' do
    it '#token_confirmed? returns status of token confirmation' do
      expect(user.token_confirmed?).to be(false)
      expect(admin_user.token_confirmed?).to be(true)
    end

    it '#nickname returns url-friendly version of #name' do
      expect(User.new(name: 'António Gonçalves de Bandarra').nickname).to eq('ant-nio-gon-alves-de-bandarra')
      expect(User.new(name: 'I am | an eccentric &*$ user').nickname).to eq('i-am-an-eccentric-user')
    end
  end
end
