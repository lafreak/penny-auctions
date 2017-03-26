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

ActiveRecord::Schema.define(version: 20170326213826) do

  create_table "auctions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "photo"
    t.datetime "finish_at"
    t.integer  "user_id"
    t.decimal  "top_price",  precision: 8, scale: 2, default: "0.01", null: false
    t.boolean  "paid",                               default: false
    t.boolean  "shipped",                            default: false
    t.boolean  "special",                            default: false
    t.boolean  "premium",                            default: false
    t.index ["user_id"], name: "index_auctions_on_user_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "auction_id"
    t.decimal  "price",      precision: 8, scale: 2, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["auction_id"], name: "index_bids_on_auction_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                          default: "",                    null: false
    t.string   "encrypted_password",                             default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0,                     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                     null: false
    t.datetime "updated_at",                                                                     null: false
    t.string   "name"
    t.decimal  "balance",                precision: 8, scale: 2, default: "0.0",                 null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "address"
    t.boolean  "blocked",                                        default: false
    t.integer  "role",                                           default: 0
    t.datetime "premium",                                        default: '2017-03-26 18:31:13'
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
