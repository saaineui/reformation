class AddWebFormIdToSubmissions < ActiveRecord::Migration[5.0]
  def change
      add_column :submissions, :web_form_id, :integer
      
      add_index :submissions, :web_form_id
  end
end
