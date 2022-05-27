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

ActiveRecord::Schema[7.0].define(version: 2022_05_27_181623) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "dashboard_id", null: false
    t.string "name"
    t.string "state"
    t.bigint "calendar_id", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_accounts_on_dashboard_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.string "name"
    t.string "layout"
    t.text "body"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "participantable_type", null: false
    t.bigint "participantable_id", null: false
    t.bigint "calendar_id", default: 0
    t.string "name"
    t.string "state"
    t.string "ancestry"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_participants_on_account_id"
    t.index ["participantable_type", "participantable_id"], name: "index_participants_on_participantable"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "user_name"
    t.string "email"
    t.datetime "confirmed_at"
    t.string "password_digest"
    t.string "unconfirmed_email"
    t.string "remember_token"
    t.string "session_token"
    t.datetime "logged_in_at"
    t.datetime "on_task_since_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "accounts", "dashboards"
  add_foreign_key "participants", "accounts"
  add_foreign_key "users", "accounts"
end
