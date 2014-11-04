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

ActiveRecord::Schema.define(version: 20141104170307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "time_entries", force: true do |t|
    t.integer  "fb_id"
    t.integer  "fb_project_id"
    t.integer  "fb_task_id"
    t.integer  "fb_staff_id"
    t.text     "notes"
    t.float    "hours"
    t.date     "date"
    t.string   "trello_card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_entries", ["trello_card_id"], name: "index_time_entries_on_trello_card_id", using: :btree

end
