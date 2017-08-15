class WebFormField < ApplicationRecord
  validates :name, presence: true

  belongs_to :web_form
  has_many :submissions_entries, dependent: :destroy

  scope :required, -> { where(required: true) }
end
