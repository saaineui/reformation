class UsersAndSessions < ActiveRecord::Migration[5.0]
  def change
    create_table "users", force: :cascade do |t|
      t.string   "name"
      t.string   "email"
      t.datetime "created_at",                      null: false
      t.datetime "updated_at",                      null: false
      t.string   "password_digest"
      t.string   "remember_digest"
      t.boolean  "admin",           default: false
    end

    add_index "users", ["email"], name: "index_users_on_email", unique: true
  end
end
