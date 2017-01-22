class WebFormField < ActiveRecord::Base    
    belongs_to :web_form
    has_many :submissions_entries

    validates :name, presence: true
end