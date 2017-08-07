class WebForm < ActiveRecord::Base
  belongs_to :user
  has_many :web_form_fields
  accepts_nested_attributes_for :web_form_fields, allow_destroy: true, reject_if: lambda {|attributes| attributes['name'].blank? }
  has_many :submissions

  validates :user, :name, presence: true
end
