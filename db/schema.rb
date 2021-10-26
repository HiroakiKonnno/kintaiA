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

ActiveRecord::Schema.define(version: 20210811074236) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "work_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "before_changed_started_at"
    t.datetime "before_changed_finished_at"
    t.string "month_sperior"
    t.string "month_status"
    t.boolean "month_modify", default: false
    t.boolean "day_modify", default: false
    t.string "day_status"
    t.boolean "day_tomorrow", default: false
    t.string "day_sperior"
    t.string "overwork_status"
    t.boolean "overwork_tomorrow", default: false
    t.datetime "overwork_time"
    t.string "overwork_note"
    t.string "overwork_sperior"
    t.boolean "overwork_modify", default: false
    t.datetime "log_changed_started_at"
    t.datetime "log_changed_finished_at"
    t.datetime "approved_time"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "kind"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "belonging"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "basic_time", default: "2021-10-24 23:00:00"
    t.datetime "work_time", default: "2021-10-24 22:30:00"
    t.integer "employee_number"
    t.integer "uid"
    t.boolean "superior", default: false
    t.datetime "designated_work_start_time", default: "2021-10-24 22:30:00"
    t.datetime "designated_work_end_time", default: "2021-10-24 22:30:00"
    t.date "log"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
