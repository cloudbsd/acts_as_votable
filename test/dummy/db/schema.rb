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

ActiveRecord::Schema.define(version: 20131226174810) do

  create_table "posts", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "votable_id",               null: false
    t.string   "votable_type",             null: false
    t.integer  "voter_id",                 null: false
    t.string   "voter_type",               null: false
    t.integer  "owner_id",                 null: false
    t.string   "owner_type",               null: false
    t.string   "action",                   null: false
    t.string   "response"
    t.integer  "weight",       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["owner_id", "owner_type"], name: "index_votes_on_owner_id_and_owner_type"
  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type"

end
