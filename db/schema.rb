# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170122031914) do

  create_table "submissions", force: :cascade do |t|
    t.string   "source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "web_form_id"
    t.index ["web_form_id"], name: "index_submissions_on_web_form_id"
  end

  create_table "submissions_entries", force: :cascade do |t|
    t.integer "web_form_field_id"
    t.integer "submission_id"
    t.string  "value"
    t.index ["submission_id"], name: "index_submissions_entries_on_submission_id"
    t.index ["web_form_field_id"], name: "index_submissions_entries_on_web_form_field_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",              default: false
    t.string   "token"
    t.string   "token_confirmation"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "web_form_fields", force: :cascade do |t|
    t.integer "web_form_id"
    t.string  "name"
    t.boolean "required",    default: false
    t.index ["web_form_id"], name: "index_web_form_fields_on_web_form_id"
  end

  create_table "web_forms", force: :cascade do |t|
    t.string  "name"
    t.integer "user_id"
    t.index ["user_id"], name: "index_web_forms_on_user_id"
  end

end