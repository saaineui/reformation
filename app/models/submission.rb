class Submission < ApplicationRecord
  validates :source, :web_form, presence: true
  
  belongs_to :web_form
  has_one :user, through: :web_form
  has_many :submissions_entries, dependent: :destroy
  
  def value_for_field(web_form_field)
    entry = submissions_entries.find_by(web_form_field: web_form_field)
    entry ? entry.value : '-'
  end
end
