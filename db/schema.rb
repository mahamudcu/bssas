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

ActiveRecord::Schema.define(version: 2026_03_30_010004) do

  create_table "alumni_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.date "event_date"
    t.string "event_type"
    t.string "location"
    t.string "status", default: "planned"
    t.decimal "budget", precision: 12, scale: 2, default: "0.0"
    t.decimal "registration_fee", precision: 10, scale: 2, default: "0.0"
    t.integer "max_attendees"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date"], name: "index_alumni_events_on_event_date"
    t.index ["status"], name: "index_alumni_events_on_status"
    t.index ["user_id"], name: "index_alumni_events_on_user_id"
  end

  create_table "committee_designations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "committee_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "committee_id"
    t.bigint "committee_designation_id"
    t.integer "added_by_id"
    t.integer "remove_by_id"
    t.integer "approve_by_id"
    t.boolean "is_approved"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["committee_designation_id"], name: "index_committee_members_on_committee_designation_id"
    t.index ["committee_id"], name: "index_committee_members_on_committee_id"
    t.index ["user_id"], name: "index_committee_members_on_user_id"
  end

  create_table "committees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "duration"
    t.date "duration_date"
    t.date "stablish_date"
    t.date "clossing_date"
    t.boolean "active"
    t.bigint "committee_designation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["committee_designation_id"], name: "index_committees_on_committee_designation_id"
  end

  create_table "event_audit_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "alumni_event_id"
    t.integer "user_id"
    t.string "action", null: false
    t.string "auditable_type"
    t.integer "auditable_id"
    t.text "change_data"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumni_event_id"], name: "index_event_audit_logs_on_alumni_event_id"
    t.index ["auditable_type", "auditable_id"], name: "index_event_audit_logs_on_auditable_type_and_auditable_id"
    t.index ["created_at"], name: "index_event_audit_logs_on_created_at"
    t.index ["user_id"], name: "index_event_audit_logs_on_user_id"
  end

  create_table "event_expenses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "alumni_event_id", null: false
    t.string "item_name", null: false
    t.text "description"
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0"
    t.decimal "unit_cost", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_cost", precision: 12, scale: 2, default: "0.0"
    t.string "category"
    t.string "vendor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumni_event_id"], name: "index_event_expenses_on_alumni_event_id"
    t.index ["category"], name: "index_event_expenses_on_category"
  end

  create_table "event_incomes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "alumni_event_id", null: false
    t.integer "contributor_id"
    t.string "income_type", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "payment_method"
    t.date "payment_date", null: false
    t.string "reference_number"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumni_event_id"], name: "index_event_incomes_on_alumni_event_id"
    t.index ["contributor_id"], name: "index_event_incomes_on_contributor_id"
    t.index ["income_type"], name: "index_event_incomes_on_income_type"
    t.index ["payment_date"], name: "index_event_incomes_on_payment_date"
  end

  create_table "event_registrations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "alumni_event_id", null: false
    t.string "status", default: "pending"
    t.bigint "payment_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumni_event_id"], name: "index_event_registrations_on_alumni_event_id"
    t.index ["payment_id"], name: "index_event_registrations_on_payment_id"
    t.index ["status"], name: "index_event_registrations_on_status"
    t.index ["user_id", "alumni_event_id"], name: "idx_event_reg_user_event", unique: true
    t.index ["user_id"], name: "index_event_registrations_on_user_id"
  end

  create_table "expense_payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "event_expense_id", null: false
    t.decimal "amount_paid", precision: 10, scale: 2, null: false
    t.date "payment_date", null: false
    t.string "payment_method"
    t.string "payment_reference"
    t.text "notes"
    t.integer "paid_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_expense_id"], name: "index_expense_payments_on_event_expense_id"
    t.index ["paid_by"], name: "index_expense_payments_on_paid_by"
    t.index ["payment_date"], name: "index_expense_payments_on_payment_date"
  end

  create_table "payment_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "payment_id"
    t.bigint "user_id"
    t.string "action", null: false
    t.text "details"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_payment_logs_on_action"
    t.index ["payment_id"], name: "index_payment_logs_on_payment_id"
    t.index ["user_id"], name: "index_payment_logs_on_user_id"
  end

  create_table "payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "payment_type", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "payment_method", null: false
    t.string "status", default: "pending"
    t.string "transaction_id"
    t.string "sslcommerz_tran_id"
    t.string "sslcommerz_val_id"
    t.text "gateway_response"
    t.bigint "subscription_id"
    t.bigint "alumni_event_id"
    t.integer "approved_by_id"
    t.datetime "approved_at"
    t.string "reference_number"
    t.text "notes"
    t.date "payment_for_month"
    t.integer "payment_for_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumni_event_id"], name: "index_payments_on_alumni_event_id"
    t.index ["approved_by_id"], name: "index_payments_on_approved_by_id"
    t.index ["payment_for_month"], name: "index_payments_on_payment_for_month"
    t.index ["payment_type"], name: "index_payments_on_payment_type"
    t.index ["sslcommerz_tran_id"], name: "index_payments_on_sslcommerz_tran_id"
    t.index ["status"], name: "index_payments_on_status"
    t.index ["subscription_id"], name: "index_payments_on_subscription_id"
    t.index ["transaction_id"], name: "index_payments_on_transaction_id", unique: true
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "photo_galleries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recent_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "logo"
    t.text "contact_address"
    t.text "aboutus"
    t.text "mission"
    t.text "vission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "plan_type", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "status", default: "active"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.date "next_due_date"
    t.boolean "auto_renew", default: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["next_due_date"], name: "index_subscriptions_on_next_due_date"
    t.index ["plan_type"], name: "index_subscriptions_on_plan_type"
    t.index ["status"], name: "index_subscriptions_on_status"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "age"
    t.string "phone"
    t.string "passing_year"
    t.string "address"
    t.string "occupation"
    t.string "bio"
    t.boolean "is_x_student"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "image"
    t.string "dob"
    t.string "role"
    t.boolean "is_active", default: false
    t.string "batch"
    t.string "string"
    t.string "student_id"
    t.string "section"
    t.string "current_company"
    t.string "present_address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "committee_members", "committee_designations"
  add_foreign_key "committee_members", "committees"
  add_foreign_key "committee_members", "users"
  add_foreign_key "committees", "committee_designations"
  add_foreign_key "event_registrations", "alumni_events"
  add_foreign_key "event_registrations", "payments"
  add_foreign_key "event_registrations", "users"
  add_foreign_key "payment_logs", "payments"
  add_foreign_key "payment_logs", "users"
  add_foreign_key "payments", "alumni_events"
  add_foreign_key "payments", "subscriptions"
  add_foreign_key "payments", "users"
  add_foreign_key "subscriptions", "users"
end
