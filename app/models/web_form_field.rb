class WebFormField < ActiveRecord::Base
    validates :web_form_id, :name, presence: true
    
    belongs_to :web_form
end