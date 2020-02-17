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

ActiveRecord::Schema.define(version: 20200212123901) do

  create_table "answers", force: :cascade do |t|
    t.integer  "ques_id",    limit: 4
    t.string   "answer",     limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "vote_count", limit: 4,   default: 0
    t.integer  "vote",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answervotes", force: :cascade do |t|
    t.integer "answer_id", limit: 4
    t.integer "user_id",   limit: 4
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,   null: false
    t.string   "question",   limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "following_id", limit: 4
    t.integer "follower_id",  limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string  "first_name",      limit: 255,                 null: false
    t.string  "last_name",       limit: 255,                 null: false
    t.integer "mobile_number",   limit: 8,                   null: false
    t.integer "age",             limit: 4,                   null: false
    t.string  "batch",           limit: 255,                 null: false
    t.string  "degree",          limit: 255,                 null: false
    t.string  "college_name",    limit: 255,                 null: false
    t.string  "register_number", limit: 255,                 null: false
    t.string  "company_name",    limit: 255
    t.string  "designation",     limit: 255
    t.string  "location",        limit: 255
    t.string  "email",           limit: 255
    t.string  "password_digest", limit: 255,                 null: false
    t.boolean "active",                      default: false
    t.boolean "admin",                       default: false
  end

end
