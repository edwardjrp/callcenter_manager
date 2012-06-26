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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120625221754) do

  create_table "clients", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "idnumber"
    t.integer  "target_address_id"
    t.integer  "target_phone_id"
    t.integer  "phones_count"
    t.integer  "addresses_count"
    t.boolean  "active"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "clients", ["email"], :name => "index_clients_on_email", :unique => true
  add_index "clients", ["idnumber"], :name => "index_clients_on_idnumber", :unique => true

  create_table "phones", :force => true do |t|
    t.string   "number"
    t.string   "ext"
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phones", ["client_id"], :name => "index_phones_on_client_id"
  add_index "phones", ["number"], :name => "index_phones_on_number"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "auth_token"
    t.string   "password_digest"
    t.integer  "role_mask"
    t.datetime "last_action_at"
    t.integer  "login_count",     :default => 0
    t.integer  "carts_count",     :default => 0
    t.string   "idnumber"
    t.boolean  "active",          :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "users", ["auth_token"], :name => "index_users_on_auth_token"
  add_index "users", ["idnumber"], :name => "index_users_on_idnumber", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
