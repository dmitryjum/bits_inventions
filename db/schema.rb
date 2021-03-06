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

ActiveRecord::Schema.define(version: 2019_02_13_023717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventions", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.text "description", null: false
    t.string "user_name", limit: 255
    t.string "user_email", limit: 255
    t.jsonb "bits", null: false
    t.text "materials", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bits"], name: "index_inventions_on_bits", using: :gin
    t.index ["title"], name: "index_inventions_on_title", unique: true
    t.index ["user_email"], name: "index_inventions_on_user_email"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
