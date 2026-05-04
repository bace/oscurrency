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

ActiveRecord::Schema.define(version: 2026_05_04_212931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.decimal "balance", precision: 8, scale: 2, default: "0.0"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "group_id"
    t.decimal "credit_limit", precision: 8, scale: 2
    t.decimal "offset", precision: 8, scale: 2, default: "0.0"
    t.decimal "paid", precision: 8, scale: 2, default: "0.0"
    t.decimal "earned", precision: 8, scale: 2, default: "0.0"
    t.decimal "reserve_percent", precision: 8, scale: 7, default: "0.0"
    t.boolean "reserve", default: false
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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.boolean "public"
    t.integer "item_id"
    t.integer "person_id"
    t.string "item_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "group_id"
    t.index ["item_id"], name: "index_activities_on_item_id"
    t.index ["item_type"], name: "index_activities_on_item_type"
    t.index ["person_id"], name: "index_activities_on_person_id"
  end

  create_table "activity_statuses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.string "name", limit: 50
    t.string "address_line_1", limit: 50
    t.string "address_line_2", limit: 50
    t.string "address_line_3", limit: 50
    t.string "city", limit: 50
    t.string "county_id", limit: 255
    t.integer "state_id"
    t.string "zipcode_plus_4", limit: 10
    t.decimal "latitude", precision: 12, scale: 8
    t.decimal "longitude", precision: 12, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "address_privacy", default: false
    t.boolean "primary", default: false
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type", limit: 255
    t.integer "associated_id"
    t.string "associated_type", limit: 255
    t.integer "user_id"
    t.string "user_type", limit: 255
    t.string "username", limit: 255
    t.string "action", limit: 255
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment", limit: 255
    t.string "remote_address", limit: 255
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bids", id: :serial, force: :cascade do |t|
    t.integer "req_id"
    t.integer "person_id"
    t.integer "status_id"
    t.decimal "estimated_hours", precision: 8, scale: 2, default: "0.0"
    t.decimal "actual_hours", precision: 8, scale: 2, default: "0.0"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "accepted_at"
    t.datetime "committed_at"
    t.datetime "completed_at"
    t.datetime "approved_at"
    t.datetime "rejected_at"
    t.string "state", limit: 255
    t.text "private_message_to_requestor"
    t.integer "group_id"
  end

  create_table "broadcast_emails", id: :serial, force: :cascade do |t|
    t.string "subject", limit: 255
    t.text "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "sent", default: false, null: false
  end

  create_table "business_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "capabilities", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "oauth_token_id"
    t.string "scope", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "invalidated_at"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index "to_tsvector('english'::regconfig, (((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)))", name: "categories_fts_idx", using: :gin
  end

  create_table "categories_offers", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "offer_id", null: false
    t.index ["category_id"], name: "index_categories_offers_on_category_id"
    t.index ["offer_id", "category_id"], name: "index_categories_offers_on_offer_id_and_category_id"
  end

  create_table "categories_people", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "person_id", null: false
    t.index ["category_id"], name: "index_categories_people_on_category_id"
    t.index ["person_id", "category_id"], name: "index_categories_people_on_person_id_and_category_id"
  end

  create_table "categories_reqs", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "req_id", null: false
    t.index ["category_id"], name: "index_categories_reqs_on_category_id"
    t.index ["req_id", "category_id"], name: "index_categories_reqs_on_req_id_and_category_id"
  end

  create_table "client_applications", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "url", limit: 255
    t.string "support_url", limit: 255
    t.string "callback_url", limit: 255
    t.string "key", limit: 50
    t.string "secret", limit: 50
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "description", limit: 255
    t.index ["key"], name: "index_client_applications_on_key", unique: true
  end

  create_table "communications", id: :serial, force: :cascade do |t|
    t.string "subject", limit: 255
    t.text "content"
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "sender_deleted_at"
    t.datetime "sender_read_at"
    t.datetime "recipient_deleted_at"
    t.datetime "recipient_read_at"
    t.datetime "replied_at"
    t.string "type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "parent_id"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_communications_on_conversation_id"
    t.index ["recipient_id"], name: "index_communications_on_recipient_id"
    t.index ["sender_id"], name: "index_communications_on_sender_id"
    t.index ["type"], name: "index_communications_on_type"
  end

  create_table "connections", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.integer "contact_id"
    t.integer "status"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id", "contact_id"], name: "index_connections_on_person_id_and_contact_id"
  end

  create_table "conversations", id: :serial, force: :cascade do |t|
    t.integer "talkable_id"
    t.string "talkable_type", limit: 255
    t.integer "exchange_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "queue", limit: 255
  end

  create_table "email_verifications", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.string "code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_email_verifications_on_code"
  end

  create_table "exchanges", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.integer "worker_id"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "group_id"
    t.integer "metadata_id"
    t.string "metadata_type", limit: 255
    t.string "recipient", limit: 255
    t.time "deleted_at"
    t.string "notes", limit: 255
  end

  create_table "feed_posts", id: :serial, force: :cascade do |t|
    t.string "feedid", limit: 255
    t.string "title", limit: 255
    t.string "urls", limit: 255
    t.string "categories", limit: 255
    t.text "content"
    t.string "authors", limit: 255
    t.datetime "date_published"
    t.datetime "last_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.integer "activity_id"
    t.index ["person_id", "activity_id"], name: "index_feeds_on_person_id_and_activity_id"
  end

  create_table "forums", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "topics_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "group_id"
    t.boolean "worldwritable", default: false
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "mode", default: 0, null: false
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "unit", limit: 255
    t.boolean "adhoc_currency", default: false
    t.boolean "mandatory", default: false
    t.decimal "default_credit_limit", precision: 8, scale: 2
    t.string "asset", limit: 255
    t.boolean "private_txns", default: false
    t.boolean "enable_forum", default: true
    t.boolean "display_balance", default: true
    t.boolean "display_earned", default: false
    t.boolean "display_paid", default: false
    t.integer "roles_mask"
    t.index "to_tsvector('english'::regconfig, (((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)))", name: "groups_fts_idx", using: :gin
  end

  create_table "groups_people", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "person_id"
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "local_encryption_keys", id: :serial, force: :cascade do |t|
    t.text "rsa_private_key"
    t.text "rsa_public_key"
  end

  create_table "member_preferences", id: :serial, force: :cascade do |t|
    t.boolean "req_notifications", default: true
    t.boolean "forum_notifications", default: true
    t.integer "membership_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "person_id"
    t.integer "status"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "roles_mask"
  end

  create_table "neighborhoods", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighborhoods_offers", id: false, force: :cascade do |t|
    t.integer "neighborhood_id", null: false
    t.integer "offer_id", null: false
    t.index ["neighborhood_id"], name: "index_neighborhoods_offers_on_neighborhood_id"
    t.index ["offer_id", "neighborhood_id"], name: "index_neighborhoods_offers_on_offer_id_and_neighborhood_id"
  end

  create_table "neighborhoods_people", id: false, force: :cascade do |t|
    t.integer "neighborhood_id", null: false
    t.integer "person_id", null: false
    t.index ["neighborhood_id"], name: "index_neighborhoods_people_on_neighborhood_id"
    t.index ["person_id", "neighborhood_id"], name: "index_neighborhoods_people_on_person_id_and_neighborhood_id"
  end

  create_table "neighborhoods_reqs", id: false, force: :cascade do |t|
    t.integer "neighborhood_id", null: false
    t.integer "req_id", null: false
    t.index ["neighborhood_id"], name: "index_neighborhoods_reqs_on_neighborhood_id"
    t.index ["req_id", "neighborhood_id"], name: "index_neighborhoods_reqs_on_req_id_and_neighborhood_id"
  end

  create_table "oauth_nonces", id: :serial, force: :cascade do |t|
    t.string "nonce", limit: 255
    t.integer "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nonce", "timestamp"], name: "index_oauth_nonces_on_nonce_and_timestamp", unique: true
  end

  create_table "oauth_tokens", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.string "type", limit: 20
    t.integer "client_application_id"
    t.string "token", limit: 50
    t.string "secret", limit: 50
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "callback_url", limit: 255
    t.string "verifier", limit: 20
    t.string "scope", limit: 255
    t.datetime "expires_at"
    t.integer "group_id"
    t.index ["token"], name: "index_oauth_tokens_on_token", unique: true
  end

  create_table "offers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.datetime "expiration_date"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "available_count"
    t.integer "group_id"
    t.string "request_token", limit: 255
    t.boolean "active", default: true
    t.integer "total_available"
    t.index "to_tsvector('english'::regconfig, (((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)))", name: "offers_fts_idx", using: :gin
  end

  create_table "open_id_authentication_associations", id: :serial, force: :cascade do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string "handle", limit: 255
    t.string "assoc_type", limit: 255
    t.binary "server_url"
    t.binary "secret"
  end

  create_table "open_id_authentication_nonces", id: :serial, force: :cascade do |t|
    t.integer "timestamp", null: false
    t.string "server_url", limit: 255
    t.string "salt", limit: 255, null: false
  end

  create_table "page_views", id: :serial, force: :cascade do |t|
    t.string "request_url", limit: 200
    t.string "ip_address", limit: 16
    t.string "referer", limit: 200
    t.string "user_agent", limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "person_id"
    t.index ["person_id", "created_at"], name: "index_page_views_on_person_id_and_created_at"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.string "name", limit: 255
    t.string "crypted_password", limit: 255
    t.string "password_salt", limit: 255
    t.string "persistence_token", limit: 255
    t.text "description"
    t.datetime "last_contacted_at"
    t.datetime "last_logged_in_at"
    t.integer "forum_posts_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false, null: false
    t.boolean "deactivated", default: false, null: false
    t.boolean "connection_notifications", default: true
    t.boolean "message_notifications", default: true
    t.boolean "email_verified"
    t.string "identity_url", limit: 255
    t.string "phone", limit: 255
    t.string "first_letter", limit: 255
    t.string "zipcode", limit: 255
    t.boolean "phoneprivacy", default: false
    t.string "language", limit: 255
    t.string "openid_identifier", limit: 255
    t.string "perishable_token", limit: 255, default: "", null: false
    t.integer "default_group_id"
    t.boolean "org", default: false
    t.boolean "activator", default: false
    t.integer "sponsor_id"
    t.boolean "broadcast_emails", default: true, null: false
    t.string "web_site_url", limit: 255
    t.string "business_name", limit: 255
    t.string "legal_business_name", limit: 255
    t.integer "business_type_id"
    t.string "title", limit: 255
    t.integer "activity_status_id"
    t.integer "plan_type_id"
    t.integer "support_contact_id"
    t.boolean "mailchimp_subscribed", default: false
    t.string "time_zone", limit: 255
    t.string "date_style", limit: 255
    t.integer "posts_per_page", default: 25
    t.index "to_tsvector('english'::regconfig, (((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)))", name: "people_fts_idx", using: :gin
    t.index ["admin"], name: "index_people_on_admin"
    t.index ["business_name"], name: "index_people_on_business_name"
    t.index ["deactivated"], name: "index_people_on_deactivated"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["name"], name: "index_people_on_name"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.string "content_type", limit: 255
    t.string "thumbnail", limit: 255
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.boolean "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "picture", limit: 255
    t.integer "photoable_id"
    t.string "photoable_type", limit: 255
    t.string "picture_for", limit: 255
    t.index ["parent_id"], name: "index_photos_on_parent_id"
  end

  create_table "plan_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "blog_id"
    t.integer "topic_id"
    t.integer "person_id"
    t.string "title", limit: 255
    t.text "body"
    t.string "type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index "to_tsvector('english'::regconfig, COALESCE(body, ''::text))", name: "posts_fts_idx", using: :gin
    t.index ["blog_id"], name: "index_posts_on_blog_id"
    t.index ["topic_id"], name: "index_posts_on_topic_id"
    t.index ["type"], name: "index_posts_on_type"
  end

  create_table "preferences", id: :serial, force: :cascade do |t|
    t.boolean "email_notifications", default: false, null: false
    t.boolean "email_verifications", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "analytics"
    t.string "server_name", limit: 255
    t.string "app_name", limit: 255
    t.text "about"
    t.boolean "demo", default: false
    t.boolean "whitelist", default: false
    t.string "gmail", limit: 255
    t.text "practice"
    t.text "steps"
    t.text "questions"
    t.text "contact"
    t.string "blog_feed_url", limit: 255
    t.string "googlemap_api_key", limit: 255
    t.text "agreement"
    t.string "new_member_notification", limit: 255
    t.text "registration_intro"
    t.integer "default_group_id"
    t.integer "topic_refresh_seconds", default: 30, null: false
    t.boolean "groups", default: true, null: false
    t.string "alt_signup_link", limit: 255
    t.boolean "protected_categories", default: false
    t.string "mailchimp_list_id", limit: 255
    t.boolean "mailchimp_send_welcome", default: true
    t.string "locale", limit: 255
    t.string "logout_url", limit: 255, default: ""
    t.boolean "public_uploads", default: false
    t.boolean "display_orgicon", default: true
    t.boolean "public_private_bid", default: false
    t.boolean "openid", default: true
    t.integer "admin_contact_id"
    t.string "app_name_notifications", default: ""
    t.string "agreement_label", default: ""
  end

  create_table "privacy_settings", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.boolean "viewable_reqs", default: true
    t.boolean "viewable_offers", default: true
    t.boolean "viewable_forum", default: true
    t.boolean "viewable_members", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_admin_histories", id: :integer, default: -> { "nextval('histories_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "message", limit: 255
    t.string "username", limit: 255
    t.integer "item"
    t.string "table", limit: 255
    t.integer "month", limit: 2
    t.bigint "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], name: "index_histories_on_item_and_table_and_month_and_year"
  end

  create_table "reqs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.decimal "estimated_hours", precision: 8, scale: 2, default: "0.0"
    t.datetime "due_date"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "biddable", default: true
    t.boolean "notifications", default: false
    t.integer "group_id"
    t.boolean "active", default: false
    t.boolean "public_bid", default: false
    t.datetime "respond_by_date"
    t.index "to_tsvector('english'::regconfig, (((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)))", name: "reqs_fts_idx", using: :gin
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name", limit: 25, null: false
    t.string "abbreviation", limit: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_zones", id: :serial, force: :cascade do |t|
    t.string "time_zone", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date_style", limit: 255, default: "mm/dd/yy"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "person_id"
    t.string "name", limit: 255
    t.integer "forum_posts_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["forum_id"], name: "index_topics_on_forum_id"
  end

  create_table "viewers", id: :serial, force: :cascade do |t|
    t.integer "topic_id"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
