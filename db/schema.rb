# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_09_015355) do

  create_table "requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date", null: false
    t.boolean "possible", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "date"], name: "index_requests_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.date "working_days", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "emp_per_day_number", null: false
    t.time "business_start_time", null: false
    t.time "business_end_time", null: false
    t.integer "regular_holiday", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "user_id"], name: "index_stores_on_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false
    t.time "available_time_start"
    t.time "available_time_end"
    t.integer "available_days"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "requests", "users"
  add_foreign_key "shifts", "users"
  add_foreign_key "stores", "users"
end
