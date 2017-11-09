class AddSubmissionsCountToWebForms < ActiveRecord::Migration[5.1]
  def change
    add_column :web_forms, :submissions_count, :integer
  end
end
