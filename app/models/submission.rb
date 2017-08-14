class Submission < ApplicationRecord
  validates :source, :web_form, presence: true
  
  belongs_to :web_form
  has_one :user, through: :web_form
  has_many :submissions_entries, dependent: :destroy
end
