class WebForm < ApplicationRecord
  validates :user, :name, presence: true
  
  belongs_to :user
  has_many :web_form_fields, dependent: :destroy
  has_many :submissions, dependent: :destroy
  
  accepts_nested_attributes_for :web_form_fields, 
                                allow_destroy: true, 
                                reject_if: :name_blank?

  private
  
  def name_blank?(attributes)
    attributes['name'].blank?
  end
end
