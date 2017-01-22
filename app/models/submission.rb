class Submission < ActiveRecord::Base    
    belongs_to :web_form
    has_many :submissions_entries
    
    validates :source, :web_form, presence: true
end