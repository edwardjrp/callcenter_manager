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

ActiveRecord::Schema.define(:version => 20120712002626) do

  create_table "addresses", :force => true do |t|
    t.integer  "client_id"
    t.integer  "street_id"
    t.string   "number"
    t.string   "unit_type"
    t.string   "unit_number"
    t.string   "postal_code"
    t.text     "delivery_instructions"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cart_products", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "quantity"
    t.integer  "product_id"
    t.integer  "bind_id"
    t.string   "options"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.boolean  "communication_failed",      :default => false
    t.string   "status_text"
    t.integer  "store_id"
    t.string   "store_order_id"
    t.string   "service_method"
    t.datetime "business_date"
    t.datetime "advance_order_time"
    t.decimal  "net_amount"
    t.decimal  "tax_amount"
    t.decimal  "tax1_amount"
    t.decimal  "tax2_amount"
    t.decimal  "payment_amount"
    t.string   "message"
    t.string   "order_text"
    t.string   "order_progress"
    t.boolean  "can_place_order"
    t.text     "delivery_instructions"
    t.string   "payment_type"
    t.string   "credit_cart_approval_name"
    t.string   "fiscal_number"
    t.string   "fiscal_type"
    t.string   "company_name"
    t.decimal  "discount"
    t.integer  "discount_auth_id"
    t.boolean  "completed",                 :default => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "carts", ["client_id"], :name => "index_carts_on_client_id"
  add_index "carts", ["discount_auth_id"], :name => "index_carts_on_discount_auth_id"
  add_index "carts", ["store_id"], :name => "index_carts_on_store_id"
  add_index "carts", ["store_order_id"], :name => "index_carts_on_store_order_id"
  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "has_options",  :default => false
    t.boolean  "type_unit",    :default => false
    t.boolean  "multi",        :default => false
    t.boolean  "hidden",       :default => false
    t.integer  "base_product"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "products", :force => true do |t|
    t.integer  "category_id"
    t.string   "productcode"
    t.string   "productname"
    t.string   "options"
    t.string   "sizecode"
    t.string   "flavorcode"
    t.string   "optionselectiongrouptype"
    t.string   "productoptionselectiongroup"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "products", ["options"], :name => "index_products_on_options"
  add_index "products", ["productcode"], :name => "index_products_on_productcode"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "ip"
    t.integer  "city_id"
    t.integer  "storeid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "streets", :force => true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
