class AlterWebFormFieldsAddSubmissions < ActiveRecord::Migration[5.0]
  def change
      change_table :web_form_fields do |t|
          t.remove :value
          t.boolean :required, :default => true
      end
      
      create_table :submissions do |t|
          t.string :source
          t.timestamps
      end
      
      create_table :submissions_entries do |t|
          t.integer :web_form_field_id
          t.integer :submission_id
          t.index :web_form_field_id
          t.index :submission_id
          t.string :value
      end
  end
end
