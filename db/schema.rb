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

ActiveRecord::Schema.define(version: 20150213204233) do

  create_table "analytics", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.text     "date1"
    t.text     "date2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "android_key"
    t.text     "iphone_key"
    t.text     "ipad_key"
    t.integer  "iPhoneUser"
    t.integer  "iPadUser"
    t.integer  "androidUser"
    t.integer  "mwUser"
    t.integer  "iPhoneSessions"
    t.integer  "iPadSessions"
    t.integer  "androidSessions"
    t.integer  "mwSessions"
    t.integer  "iPhoneMedianSL"
    t.integer  "iPadMedianSL"
    t.integer  "androidMedianSL"
    t.integer  "iPhoneAvgActiveUsers"
    t.integer  "iPadAvgActiveUsers"
    t.integer  "androidAvgActiveUsers"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commenter",  limit: 255
    t.text     "body"
    t.integer  "tool_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["tool_id"], name: "index_comments_on_tool_id"

  create_table "tools", force: :cascade do |t|
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
