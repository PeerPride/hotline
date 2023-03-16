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

ActiveRecord::Schema[7.0].define(version: 2023_03_16_232936) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allowlisted_jwts", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_allowlisted_jwts_on_jti", unique: true
    t.index ["user_id"], name: "index_allowlisted_jwts_on_user_id"
  end

  create_table "contact_phones", force: :cascade do |t|
    t.bigint "contact_id"
    t.string "phone"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_phones_on_contact_id"
    t.index ["phone"], name: "index_contact_phones_on_phone"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "codename"
    t.text "notes"
    t.boolean "blocked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codename"], name: "index_contacts_on_codename", unique: true
  end

  create_table "conversation_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_active", default: true
    t.integer "item_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.string "method"
    t.text "notes"
    t.string "provider_id"
    t.integer "length"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contact_phone_id", null: false
    t.bigint "conversation_category_id"
    t.string "recording_id"
    t.boolean "is_voicemail", default: false
    t.datetime "voicemail_acknowledged", precision: nil
    t.index ["contact_phone_id"], name: "index_conversations_on_contact_phone_id"
    t.index ["conversation_category_id"], name: "index_conversations_on_conversation_category_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages_users", id: false, force: :cascade do |t|
    t.bigint "language_id"
    t.bigint "user_id"
    t.index ["language_id"], name: "index_languages_users_on_language_id"
    t.index ["user_id"], name: "index_languages_users_on_user_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.boolean "is_active", default: true
    t.string "phone_greeting_message"
    t.string "greeting_audio"
    t.boolean "record_calls", default: true
    t.integer "recording_save_length", default: 365
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepts_phone_calls", default: true
    t.boolean "accepts_text_messages", default: false
    t.boolean "accepts_voicemails", default: true
    t.text "no_operators_phone_message"
    t.text "no_operators_text_message"
    t.text "voicemail_greeting"
    t.index ["name"], name: "index_lines_on_name", unique: true
    t.index ["number"], name: "index_lines_on_number"
  end

  create_table "tag_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "item_order"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_groups", force: :cascade do |t|
    t.string "subject"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_tag_groups_on_conversation_id"
  end

  create_table "tag_instances", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "tag_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_group_id"], name: "index_tag_instances_on_tag_group_id"
    t.index ["tag_id"], name: "index_tag_instances_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_active", default: true
    t.integer "item_order"
    t.bigint "tag_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_category_id"], name: "index_tags_on_tag_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "on_call_name"
    t.string "pronouns"
    t.text "bio"
    t.string "phone_number"
    t.string "timezone", default: "America/New_York"
    t.integer "break_between_conversations", limit: 2, default: 300
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "allowlisted_jwts", "users", on_delete: :cascade
  add_foreign_key "conversations", "contact_phones"
  add_foreign_key "conversations", "conversation_categories"
  add_foreign_key "tag_instances", "tag_groups"
  add_foreign_key "tag_instances", "tags"
end
