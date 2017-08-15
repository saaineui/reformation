class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :email, 
            presence: true, 
            length: { maximum: 50 }, 
            format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: { case_sensitive: false }

  before_save :normalize_email
  
  has_secure_password
  has_secure_token

  has_many :web_forms, dependent: :destroy

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost 
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def token_confirmed?
    token.eql?(token_confirmation)
  end
  
  def nickname
    name.downcase.gsub(/(\s|\W)+/, '-')
  end
  
  private
  
  def normalize_email
    self.email = email.downcase
  end
end
