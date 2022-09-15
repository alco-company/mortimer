# Attendance

workflow is something likes this

*  1 - create employee - select wage_period and set signed_pupils
*  2 - send token_link to employee
*  3 - employee punches 'in' (with a set of pupils)
*  4 - create worksheet if none in period
*  5 - create task and assign to employee and pupils and worksheet
*  6 - create task_transaction
*  7 - employee punches 'pause' (on first break)
*  8 - create task_transaction
*  9 - employee punches 'resume'
* 10 - create task_transaction
* 11 - employee punches 'out'
* 12 - create task_transaction
* 13 - calculate duration, update task and close task
* 14 - calculate duration, update worksheet
* 15 - every night run through worksheets and close worksheet if current time is > to_at





> employee (asset) *-* pupils (asset)

> employee (asset) -* assignments *- task (event)
> pupil (asset) -* assignments *- task (event)

> employee
>   wage_period -> 7, 14, 30 (days)
>   next_period -> first day of next period
>   state -> 'in', 'out', 'sick', 'holiday', ...
>   department -> t.bigint "stock_id" from old version
>   compensation_plan_id -> what compensation package does the employee enjoy

> compensation_plan
>   regular_hours -> '00:00-00:00'
>   overtime_hours_1 -> '00:00' hrs:minutes around regular hours
>   overtime_hours_2 -> '00:00' hrs:minutes outside overtime 1

> worksheet
>   employee_id
>   state -> 'current', 'closed', 'settled'
>   from_at -> employee first day of wage period
>   to_at -> last day of employee wage period
>   settled_at -> day of settlement for worksheet
>   minutes_present -> total minutes between 'punched in' and 'punched out'
>   minutes_adjourned -> total minutes between 'pause' and 'resume'
>   minutes_regular_work -> 
>   minutes_overtime_1_work -> 
>   minutes_overtime_2_work -> 

> tasks_worksheets

> task (event)
>   state 'working','paused','done'
>   duration -> total minutes on task
>   location
>   purpose
>   created_at -> initial punch
>   updated_at -> state change
>   started_at -> when employee punches 'in'
>   ended_at -> when employee punches 'out'

> task_transaction 
>   task_id
>   employee_id
>   punch_clock_id
>   punch_action -> 'in', 'out', 'pause', 'resume'
>   remote_ip_addr -> recorded addr punched from
>   punched_at -> system time on punch_clock (or device)
>   created_at -> when employee punched


```

create_table "client_ips", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.string "ip"
  t.datetime "valid_until"
  t.text "fulltext"
  t.datetime "deleted_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.bigint "account_id"
  t.index ["account_id"], name: "index_client_ips_on_account_id"
end

create_table "client_ips_printservers", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "client_ip_id", null: false
  t.bigint "printserver_id", null: false
end

create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "account_id"
  t.bigint "user_id"
  t.string "forename"
  t.string "surname"
  t.string "social_security_number"
  t.string "barcode"
  t.string "state"
  t.text "fulltext"
  t.datetime "deleted_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["account_id"], name: "index_employees_on_account_id"
  t.index ["user_id"], name: "index_employees_on_user_id"
end

create_table "enter_leave_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "account_id"
  t.bigint "employee_id"
  t.bigint "enter_leave_id"
  t.bigint "punch_clock_id"
  t.string "enter_leave_action"
  t.string "ip_addr"
  t.datetime "deleted_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.datetime "punched_at"
  t.integer "extra_time"
  t.index ["account_id"], name: "index_enter_leave_transactions_on_account_id"
  t.index ["employee_id"], name: "index_enter_leave_transactions_on_employee_id"
  t.index ["enter_leave_id"], name: "index_enter_leave_transactions_on_enter_leave_id"
  t.index ["punch_clock_id"], name: "index_enter_leave_transactions_on_punch_clock_id"
end

create_table "enter_leaves", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "account_id"
  t.bigint "employee_id"
  t.integer "minutes_present"
  t.integer "minutes_adjourned"
  t.integer "minutes_work"
  t.datetime "settled_at"
  t.datetime "deleted_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.text "fulltext"
  t.index ["account_id"], name: "index_enter_leaves_on_account_id"
  t.index ["employee_id"], name: "index_enter_leaves_on_employee_id"
end

create_table "printservers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "account_id"
  t.string "location"
  t.string "mac_addr"
  t.integer "port"
  t.text "fulltext"
  t.datetime "deleted_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["account_id"], name: "index_printservers_on_account_id"
end

create_table "punch_clocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "account_id"
  t.string "name"
  t.string "location"
  t.string "ip_addr"
  t.datetime "last_used_at"
  t.datetime "deleted_at"
  t.text "fulltext"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["account_id"], name: "index_punch_clocks_on_account_id"
end


create_table "motds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "account_id"
  t.text "content"
  t.datetime "valid_from"
  t.text "fulltext"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["account_id"], name: "index_motds_on_account_id"
end


create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.bigint "account_id"
  t.string "email", default: "", null: false
  t.string "encrypted_password", default: ""
  t.string "reset_password_token"
  t.datetime "reset_password_sent_at"
  t.datetime "remember_created_at"
  t.integer "sign_in_count", default: 0, null: false
  t.datetime "current_sign_in_at"
  t.datetime "last_sign_in_at"
  t.string "current_sign_in_ip"
  t.string "last_sign_in_ip"
  t.string "confirmation_token"
  t.datetime "confirmed_at"
  t.datetime "confirmation_sent_at"
  t.string "unconfirmed_email"
  t.integer "failed_attempts", default: 0, null: false
  t.string "unlock_token"
  t.datetime "locked_at"
  t.datetime "deleted_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "invitation_token"
  t.datetime "invitation_created_at"
  t.datetime "invitation_sent_at"
  t.datetime "invitation_accepted_at"
  t.integer "invitation_limit"
  t.string "invited_by_type"
  t.bigint "invited_by_id"
  t.integer "invitations_count", default: 0
  t.string "name"
  t.string "authorizations"
  t.string "rfid"
  t.string "state", default: "invited"
  t.bigint "dashboard_id"
  t.string "api_token"
  t.index ["account_id"], name: "index_users_on_account_id"
  t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  t.index ["dashboard_id"], name: "fk_rails_0e69c0aa68"
  t.index ["email"], name: "index_users_on_email", unique: true
  t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  t.index ["invitations_count"], name: "index_users_on_invitations_count"
  t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
  t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
  t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  t.index ["stock_id"], name: "fk_rails_a0bd87d269"
  t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
end

```