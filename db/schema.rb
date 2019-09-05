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

ActiveRecord::Schema.define(version: 20160720025040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "object_type_id"
    t.integer  "object_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "like_count",     default: 0
    t.string   "body"
    t.index ["object_type_id"], name: "index_comments_on_object_type_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "emails", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "subject"
    t.string   "body"
    t.integer  "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_emails_on_event_id", using: :btree
  end

  create_table "emails_users", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "sent"
    t.datetime "read"
    t.integer  "email_id"
    t.index ["email_id"], name: "index_emails_users_on_email_id", using: :btree
    t.index ["user_id"], name: "index_emails_users_on_user_id", using: :btree
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "display_order"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "profile_img"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.string   "slug"
    t.string   "location_name"
    t.string   "location_address"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.datetime "start",                                                            null: false
    t.datetime "end"
    t.datetime "deadline"
    t.integer  "event_type_id",                                    default: 0
    t.integer  "created_by"
    t.string   "key"
    t.string   "header_img_file_name"
    t.string   "header_img_content_type"
    t.integer  "header_img_file_size"
    t.datetime "header_img_updated_at"
    t.decimal  "location_lat",            precision: 10, scale: 6
    t.decimal  "location_lng",            precision: 10, scale: 6
    t.integer  "status",                                           default: 1
    t.integer  "kick_by",                                          default: 1
    t.boolean  "show_resources",                                   default: true
    t.boolean  "show_dollars",                                     default: true
    t.integer  "timezone_offset",                                  default: 0
    t.string   "timezone_name",                                    default: "UTC"
    t.string   "checkout_text"
    t.string   "location_city"
    t.string   "location_state"
    t.string   "location_country"
    t.boolean  "published",                                        default: false
    t.index ["created_by"], name: "index_events_on_created_by", using: :btree
    t.index ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
  end

  create_table "events_users", force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "event_id", null: false
    t.integer "status"
    t.integer "relation"
  end

  create_table "fb_friends", force: :cascade do |t|
    t.string   "user_uid",   null: false
    t.string   "friend_uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "object_type_id"
    t.integer  "object_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["object_type_id"], name: "index_likes_on_object_type_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "object_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.decimal  "cost",        precision: 8, scale: 2, default: "0.0", null: false
    t.string   "description"
    t.integer  "order_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "item_type",                           default: 1
    t.index ["order_id"], name: "index_order_items_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status"
    t.integer  "events_user_id"
    t.integer  "payment_id"
    t.string   "stripe_customer_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "contribution_note"
    t.boolean  "processed",          default: false
    t.datetime "processed_at"
    t.index ["events_user_id"], name: "index_orders_on_events_user_id", using: :btree
    t.index ["payment_id"], name: "index_orders_on_payment_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.string   "stripe_customer_id"
    t.integer  "payment_type",                 default: 4
    t.string   "number",             limit: 4
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.string   "address_line1"
    t.string   "address_zip"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "default",                      default: true
    t.string   "nick_name"
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.text     "title"
    t.text     "body"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id"
    t.boolean  "pinned",        default: false
    t.integer  "event_id"
    t.integer  "comment_count", default: 0
    t.integer  "like_count",    default: 0
    t.index ["event_id"], name: "index_posts_on_event_id", using: :btree
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  end

  create_table "resource_price_breaks", force: :cascade do |t|
    t.integer  "break_level",                            default: 0,     null: false
    t.decimal  "price_per_unit", precision: 8, scale: 2, default: "0.0", null: false
    t.integer  "resource_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.index ["resource_id"], name: "index_resource_price_breaks_on_resource_id", using: :btree
  end

  create_table "resource_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price"
    t.boolean  "private",          default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "resource_type_id"
    t.index ["resource_type_id"], name: "index_resources_on_resource_type_id", using: :btree
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.text     "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type", using: :btree
    t.index ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
    t.index ["url"], name: "index_shortened_urls_on_url", using: :btree
  end

  create_table "tier_resources", force: :cascade do |t|
    t.decimal  "price",       precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "tier_id"
    t.integer  "resource_id",                                         null: false
    t.index ["resource_id"], name: "index_tier_resources_on_resource_id", using: :btree
    t.index ["tier_id"], name: "index_tier_resources_on_tier_id", using: :btree
  end

  create_table "tiers", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "min_attendee_count",                         default: 0
    t.string   "profile_img"
    t.decimal  "contribution",       precision: 8, scale: 2, default: "0.0", null: false
    t.string   "contribution_note"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "event_id"
    t.integer  "max_attendee_count",                         default: 0
    t.decimal  "base_cost",                                  default: "0.0"
    t.decimal  "cost_per_attendee",  precision: 8, scale: 2
    t.integer  "calculation_method",                         default: 1
    t.boolean  "kicked",                                     default: false
    t.boolean  "user_set_price",                             default: false
    t.index ["event_id"], name: "index_tiers_on_event_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "provider"
    t.string   "uid"
    t.datetime "last_sign_out_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_customer_id"
    t.string   "profile_name"
    t.boolean  "admin",                    default: false
    t.string   "profile_img_file_name"
    t.string   "profile_img_content_type"
    t.integer  "profile_img_file_size"
    t.datetime "profile_img_updated_at"
    t.string   "fb_access_token"
    t.string   "slug"
    t.string   "mobile_number"
    t.string   "profile_img_url"
    t.string   "bio"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["provider"], name: "index_users_on_provider", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
    t.index ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  end

  add_foreign_key "comments", "object_types"
  add_foreign_key "comments", "users"
  add_foreign_key "emails", "events"
  add_foreign_key "emails_users", "emails"
  add_foreign_key "emails_users", "users"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "users", column: "created_by"
  add_foreign_key "fb_friends", "users", column: "friend_uid", primary_key: "uid"
  add_foreign_key "fb_friends", "users", column: "user_uid", primary_key: "uid"
  add_foreign_key "likes", "object_types"
  add_foreign_key "likes", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "events_users"
  add_foreign_key "orders", "payments"
  add_foreign_key "payments", "users"
  add_foreign_key "posts", "events"
  add_foreign_key "posts", "users"
  add_foreign_key "resource_price_breaks", "resources"
  add_foreign_key "resources", "resource_types"
  add_foreign_key "tier_resources", "resources"
  add_foreign_key "tier_resources", "tiers"
  add_foreign_key "tiers", "events"
end
