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

ActiveRecord::Schema.define(version: 20160329201936) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.string  "province"
    t.decimal "tax_percent", precision: 5, scale: 3
    t.string  "tax_name"
    t.string  "user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "statement_periods", force: :cascade do |t|
    t.string  "from"
    t.string  "to"
    t.integer "draft_days"
  end

  create_table "statement_time_entries", force: :cascade do |t|
    t.integer "statement_id",  null: false
    t.integer "time_entry_id", null: false
    t.string  "state"
  end

  create_table "statement_transitions", force: :cascade do |t|
    t.string   "to_state",                    null: false
    t.text     "metadata",     default: "{}"
    t.integer  "sort_key",                    null: false
    t.integer  "statement_id",                null: false
    t.boolean  "most_recent",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "statement_transitions", ["statement_id", "most_recent"], name: "index_statement_transitions_parent_most_recent", unique: true, where: "most_recent", using: :btree
  add_index "statement_transitions", ["statement_id", "sort_key"], name: "index_statement_transitions_parent_sort", unique: true, using: :btree

  create_table "statements", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "from"
    t.datetime "to"
    t.datetime "post_date"
  end

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
    t.decimal  "holiday_rate_multiplier", precision: 4, scale: 2
    t.boolean  "legacy"
    t.string   "holiday_code"
    t.boolean  "has_tax"
    t.string   "tax_desc"
    t.decimal  "tax_percent",             precision: 5, scale: 3
    t.integer  "location_id"
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
    t.boolean  "hourly",                                          default: true
    t.float    "rate"
    t.float    "secondary_rate"
    t.decimal  "holiday_rate_multiplier", precision: 4, scale: 2, default: 1.5
    t.boolean  "password_reset_required"
    t.string   "company_name"
    t.string   "password_reset_token"
    t.string   "tax_number"
    t.integer  "location_id"
    t.boolean  "has_tax"
    t.boolean  "receive_admin_email",                             default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
