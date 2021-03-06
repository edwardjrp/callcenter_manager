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

ActiveRecord::Schema.define(:version => 20130202150613) do

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

  add_index "addresses", ["client_id"], :name => "index_addresses_on_client_id"
  add_index "addresses", ["street_id"], :name => "index_addresses_on_street_id"

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "areas", ["city_id"], :name => "index_areas_on_city_id"
  add_index "areas", ["store_id"], :name => "index_areas_on_store_id"

  create_table "cart_coupons", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "coupon_id"
    t.string   "code"
    t.text     "target_products"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "cart_coupons", ["cart_id"], :name => "index_cart_coupons_on_cart_id"
  add_index "cart_coupons", ["coupon_id"], :name => "index_cart_coupons_on_coupon_id"

  create_table "cart_products", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "quantity"
    t.integer  "product_id"
    t.integer  "bind_id"
    t.string   "options"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.decimal  "priced_at"
    t.string   "coocking_instructions"
  end

  add_index "cart_products", ["cart_id", "product_id"], :name => "index_cart_products_on_cart_id_and_product_id"
  add_index "cart_products", ["cart_id"], :name => "index_cart_products_on_cart_id"
  add_index "cart_products", ["product_id"], :name => "index_cart_products_on_product_id"

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.boolean  "communication_failed",        :default => false
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
    t.string   "credit_card_approval_number"
    t.string   "fiscal_number"
    t.string   "fiscal_type"
    t.string   "company_name"
    t.decimal  "discount"
    t.integer  "discount_auth_id"
    t.boolean  "completed",                   :default => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "message_mask"
    t.integer  "reason_id"
    t.datetime "complete_on"
    t.datetime "placed_at"
    t.boolean  "exonerated"
    t.datetime "started_on"
    t.integer  "exoneration_authorizer"
    t.string   "creditcard_number"
    t.string   "fiscal_company_name"
    t.boolean  "offline",                     :default => false
    t.datetime "communication_failed_on"
  end

  add_index "carts", ["client_id"], :name => "index_carts_on_client_id"
  add_index "carts", ["discount_auth_id"], :name => "index_carts_on_discount_auth_id"
  add_index "carts", ["reason_id"], :name => "index_carts_on_reason_id"
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
    t.boolean  "has_sides",    :default => false
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
    t.boolean  "active",            :default => true
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "imported",          :default => false
  end

  add_index "clients", ["email"], :name => "index_clients_on_email", :unique => true
  add_index "clients", ["idnumber"], :name => "index_clients_on_idnumber", :unique => true

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.text     "description"
    t.text     "custom_description"
    t.text     "generated_description"
    t.decimal  "minimum_price"
    t.boolean  "hidden"
    t.boolean  "secure"
    t.string   "effective_days"
    t.string   "order_sources"
    t.string   "service_methods"
    t.date     "expiration_date"
    t.date     "effective_date"
    t.boolean  "enable",                :default => true
    t.boolean  "discontinued",          :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.text     "target_products"
  end

  add_index "coupons", ["code"], :name => "index_coupons_on_code", :unique => true

  create_table "import_events", :force => true do |t|
    t.integer  "import_log_id"
    t.string   "name"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "import_events", ["import_log_id"], :name => "index_import_events_on_import_log_id"

  create_table "import_logs", :force => true do |t|
    t.string   "log_type"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "discontinued",                :default => false
  end

  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["options"], :name => "index_products_on_options"
  add_index "products", ["productcode"], :name => "index_products_on_productcode"

  create_table "reasons", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.string   "csv_file"
    t.string   "pdf_file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "store_products", :force => true do |t|
    t.integer  "store_id"
    t.integer  "product_id"
    t.boolean  "available",     :default => false
    t.datetime "depleted_time"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "store_products", ["product_id", "store_id"], :name => "index_store_products_on_product_id_and_store_id"
  add_index "store_products", ["product_id"], :name => "index_store_products_on_product_id"
  add_index "store_products", ["store_id"], :name => "index_store_products_on_store_id"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "ip"
    t.integer  "city_id"
    t.integer  "storeid"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "discontinued",   :default => false
    t.text     "store_schedule"
  end

  add_index "stores", ["city_id"], :name => "index_stores_on_city_id"

  create_table "streets", :force => true do |t|
    t.string   "name"
    t.integer  "area_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "store_id"
  end

  add_index "streets", ["area_id"], :name => "index_streets_on_area_id"
  add_index "streets", ["store_id"], :name => "index_streets_on_store_id"

  create_table "tax_numbers", :force => true do |t|
    t.string   "rnc"
    t.string   "fiscal_type"
    t.boolean  "verified",     :default => false
    t.integer  "client_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "company_name"
  end

  add_index "tax_numbers", ["client_id"], :name => "index_tax_numbers_on_client_id"

  create_table "taxpayer_identifications", :force => true do |t|
    t.string "idnumber"
    t.string "full_name"
    t.string "company_name"
    t.string "ocupation"
    t.string "street"
    t.string "street_number"
    t.string "zone"
    t.string "other"
    t.string "start_time"
    t.string "state"
    t.string "kind"
  end

  add_index "taxpayer_identifications", ["idnumber"], :name => "index_taxpayer_identifications_on_idnumber", :unique => true

  create_table "user_carts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cart_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_carts", ["cart_id"], :name => "index_user_carts_on_cart_id"
  add_index "user_carts", ["user_id"], :name => "index_user_carts_on_user_id"

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

end
