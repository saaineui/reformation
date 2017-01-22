class ChangeRequiredDefault < ActiveRecord::Migration[5.0]
  def change
      change_column :web_form_fields, :required, :boolean, :default => false
  end
end
