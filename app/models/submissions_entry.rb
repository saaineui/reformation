class SubmissionsEntry < ApplicationRecord 
  validates :submission, :web_form_field, presence: true
  validates :value, presence: true, if: :required?

  belongs_to :submission
  belongs_to :web_form_field
  
  delegate :required?, to: :web_form_field, allow_nil: true
end
