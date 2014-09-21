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

ActiveRecord::Schema.define(version: 0) do

  create_table "categories", force: true do |t|
    t.string "name", limit: 128, default: "", null: false
  end

  create_table "comparisons", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "study_id"
    t.integer "category_id"
  end

  create_table "items", force: true do |t|
    t.integer "study_id",                              null: false
    t.string  "name",        limit: 128,  default: "", null: false
    t.string  "description", limit: 1024, default: "", null: false
    t.string  "link",        limit: 256
  end

  create_table "members", force: true do |t|
    t.integer "category_id",                           null: false
    t.string  "name",        limit: 128,  default: "", null: false
    t.string  "description", limit: 1024, default: "", null: false
    t.string  "link",        limit: 256,  default: "", null: false
  end

  create_table "ranks", force: true do |t|
    t.integer "comparison_id", null: false
    t.integer "item_id",       null: false
    t.integer "rank",          null: false
  end

  create_table "studies", force: true do |t|
    t.integer "user_id",                          null: false
    t.string  "name",    limit: 128, default: "", null: false
    t.boolean "active",                           null: false
  end

  create_table "users", force: true do |t|
    t.string "email", limit: 64, default: "", null: false
    t.string "guid",  limit: 64, default: "", null: false
  end

  add_index "users", ["email"], name: "email", unique: true, using: :btree
  add_index "users", ["guid"], name: "guid", unique: true, using: :btree

end
