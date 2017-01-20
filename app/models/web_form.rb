class WebForm < ActiveRecord::Base
    validates :user_id, :name, presence: true
    
    belongs_to :user
    has_many :web_form_fields
end