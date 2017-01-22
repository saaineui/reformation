class SubmissionsEntry < ActiveRecord::Base    
    belongs_to :submission
    belongs_to :web_form_field
    
    validates :submission, :web_form_field, presence: true
    validates :value, presence: true, if: :is_required?
 
    def is_required?
        web_form_field.required?
    end
end