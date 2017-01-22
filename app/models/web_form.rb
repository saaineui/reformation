class WebForm < ActiveRecord::Base    
    belongs_to :user
    has_many :web_form_fields
    has_many :submissions

    validates :user, :name, presence: true
end