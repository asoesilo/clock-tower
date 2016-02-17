# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160217012218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "apply_secondary_rate"
  end

  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "time_entries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "task_id"
    t.date     "entry_date"
    t.float    "duration_in_hours"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rate"
    t.boolean  "apply_rate"
    t.boolean  "is_holiday"
    t.integer  "holiday_rate_multiplier"
    t.boolean  "legacy"
  end

  add_index "time_entries", ["entry_date"], name: "index_time_entries_on_entry_date", using: :btree
  add_index "time_entries", ["project_id"], name: "index_time_entries_on_project_id", using: :btree
  add_index "time_entries", ["task_id"], name: "index_time_entries_on_task_id", using: :btree
  add_index "time_entries", ["user_id"], name: "index_time_entries_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "is_admin"
    t.boolean  "active"
    t.boolean  "hourly",                  default: true
    t.float    "rate"
    t.float    "secondary_rate"
    t.float    "holiday_rate_multiplier", default: 1.5
    t.boolean  "password_reset_required"
    t.string   "company_name"
    t.string   "password_reset_token"
    t.string   "tax_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
