# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140301230936) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_players", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.boolean  "alive",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "assassin_threshold", default: 10
    t.string   "name",               default: "Umbra Agency"
    t.integer  "min_difficulty",     default: 1
    t.integer  "max_difficulty",     default: 2
    t.integer  "mission_count",      default: 0
    t.boolean  "started",            default: false
    t.boolean  "completed"
    t.integer  "time_limit"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missions", force: true do |t|
    t.string   "description", limit: 160
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_missions", force: true do |t|
    t.integer  "mission_id"
    t.integer  "game_id"
    t.integer  "handler_id"
    t.integer  "agent_id"
    t.integer  "round_id"
    t.integer  "target_id"
    t.datetime "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.datetime "round_start"
    t.datetime "round_end"
    t.integer  "game_id"
    t.integer  "difficulty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "user_name"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "involved",               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
