# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_28_073438) do
  create_table "submissions", force: :cascade do |t|
    t.string "source"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "web_form_id"
    t.index ["web_form_id"], name: "index_submissions_on_web_form_id"
  end

  create_table "submissions_entries", force: :cascade do |t|
    t.integer "web_form_field_id"
    t.integer "submission_id"
    t.string "value"
    t.index ["submission_id"], name: "index_submissions_entries_on_submission_id"
    t.index ["web_form_field_id"], name: "index_submissions_entries_on_web_form_field_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "token"
    t.string "token_confirmation"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "web_form_fields", force: :cascade do |t|
    t.integer "web_form_id"
    t.string "name"
    t.boolean "required", default: false
    t.index ["web_form_id"], name: "index_web_form_fields_on_web_form_id"
  end

  create_table "web_forms", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "submissions_count"
    t.index ["user_id"], name: "index_web_forms_on_user_id"
  end

end
