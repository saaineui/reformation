class WebFormField < ActiveRecord::Base    
    belongs_to :web_form
    has_many :submissions_entries

    validates :web_form, :name, :required, presence: true
end