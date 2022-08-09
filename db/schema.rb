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

ActiveRecord::Schema[7.0].define(version: 2022_08_09_130738) do
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

  create_table "accounts_services", id: false, force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "service_id", null: false
    t.index ["account_id", "service_id"], name: "index_accounts_services_on_account_id_and_service_id"
    t.index ["service_id", "account_id"], name: "index_accounts_services_on_service_id_and_account_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assets", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "assetable_type", null: false
    t.bigint "assetable_id", null: false
    t.bigint "calendar_id"
    t.string "name"
    t.string "state"
    t.integer "position"
    t.string "ancestry"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_assets_on_account_id"
    t.index ["assetable_type", "assetable_id"], name: "index_assets_on_assetable"
    t.index ["calendar_id"], name: "index_assets_on_calendar_id"
    t.index ["name"], name: "index_assets_on_name"
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "assignable_type", null: false
    t.bigint "assignable_id", null: false
    t.string "assignable_role"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignable_type", "assignable_id"], name: "index_assignments_on_assignable"
    t.index ["event_id"], name: "index_assignments_on_event_id"
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

  create_table "employees", force: :cascade do |t|
    t.string "access_token"
    t.string "job_title"
    t.string "pin_code"
    t.datetime "birthday"
    t.datetime "hired_at"
    t.integer "base_salary"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees_pupils", id: false, force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "pupil_id", null: false
    t.index ["employee_id", "pupil_id"], name: "index_employees_pupils_on_employee_id_and_pupil_id"
    t.index ["pupil_id", "employee_id"], name: "index_employees_pupils_on_pupil_id_and_employee_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "eventable_type", null: false
    t.bigint "eventable_id", null: false
    t.bigint "calendar_id", null: false
    t.string "name"
    t.string "state"
    t.integer "position"
    t.string "ancestry"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "minutes_spent"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_events_on_account_id"
    t.index ["calendar_id"], name: "index_events_on_calendar_id"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
  end

  create_table "participant_teams", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.bigint "team_id", null: false
    t.string "team_role", default: "member"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_participant_teams_on_participant_id"
    t.index ["team_id"], name: "index_participant_teams_on_team_id"
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

  create_table "products", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.string "supplier_barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "time_zone"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "pupils", force: :cascade do |t|
    t.integer "time_spent_minutes"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roleables", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.string "roleable_type", null: false
    t.bigint "roleable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_roleables_on_role_id"
    t.index ["roleable_type", "roleable_id"], name: "index_roleables_on_roleable"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name"
    t.string "ancestry"
    t.string "context"
    t.integer "position"
    t.string "state"
    t.string "role"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_roles_on_account_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "menu_label"
    t.string "index_url"
    t.string "service_model"
    t.string "service_group"
    t.string "state"
    t.text "menu_icon"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_item_transactions", force: :cascade do |t|
    t.bigint "stocked_product_id", null: false
    t.bigint "stock_location_id", null: false
    t.bigint "stock_item_id", null: false
    t.integer "quantity"
    t.string "unit"
    t.string "barcodes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_item_id"], name: "index_stock_item_transactions_on_stock_item_id"
    t.index ["stock_location_id"], name: "index_stock_item_transactions_on_stock_location_id"
    t.index ["stocked_product_id"], name: "index_stock_item_transactions_on_stocked_product_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.bigint "stocked_product_id", null: false
    t.bigint "stock_location_id", null: false
    t.string "batch_number"
    t.datetime "expire_at"
    t.integer "quantity"
    t.string "batch_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_items_on_stock_id"
    t.index ["stock_location_id"], name: "index_stock_items_on_stock_location_id"
    t.index ["stocked_product_id"], name: "index_stock_items_on_stocked_product_id"
  end

  create_table "stock_locations", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.string "location_barcode"
    t.boolean "open_shelf"
    t.integer "shelf_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_locations_on_stock_id"
  end

  create_table "stocked_products", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "stock_id", null: false
    t.bigint "stock_location_id", null: false
    t.integer "quantity"
    t.string "stock_unit"
    t.datetime "consolidated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stocked_products_on_product_id"
    t.index ["stock_id"], name: "index_stocked_products_on_stock_id"
    t.index ["stock_location_id"], name: "index_stocked_products_on_stock_location_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "access_token"
    t.datetime "last_heart_beat_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_stocks_on_access_token", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "product_resource"
    t.string "gtin_prefix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "duration"
    t.datetime "planned_start_at"
    t.datetime "planned_end_at"
    t.string "location"
    t.string "purpose"
    t.text "recurring_ical"
    t.datetime "recurring_end_at"
    t.boolean "full_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "task_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_teams_on_task_id"
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
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assets", "accounts"
  add_foreign_key "assets", "calendars"
  add_foreign_key "assignments", "events"
  add_foreign_key "events", "accounts"
  add_foreign_key "events", "calendars"
  add_foreign_key "participant_teams", "participants"
  add_foreign_key "participant_teams", "teams"
  add_foreign_key "participants", "accounts"
  add_foreign_key "products", "suppliers"
  add_foreign_key "profiles", "users"
  add_foreign_key "roleables", "roles"
  add_foreign_key "roles", "accounts"
  add_foreign_key "stock_item_transactions", "stock_items"
  add_foreign_key "stock_item_transactions", "stock_locations"
  add_foreign_key "stock_item_transactions", "stocked_products"
  add_foreign_key "stock_items", "stock_locations"
  add_foreign_key "stock_items", "stocked_products"
  add_foreign_key "stock_items", "stocks"
  add_foreign_key "stock_locations", "stocks"
  add_foreign_key "stocked_products", "products"
  add_foreign_key "stocked_products", "stock_locations"
  add_foreign_key "stocked_products", "stocks"
  add_foreign_key "teams", "tasks"
  add_foreign_key "users", "accounts"
end
