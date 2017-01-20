class Add < ActiveRecord::Migration[5.0]
  def change
      change_table :users do |t|
          t.string :token
          t.string :token_confirmation
      end
      
      create_table :web_forms do |t|
          t.string :name
          t.integer :user_id
          t.index :user_id
      end

      create_table :web_form_fields do |t|
          t.index :web_form_id
          t.integer :web_form_id
          t.string :name
          t.string :value
      end
  end
end
