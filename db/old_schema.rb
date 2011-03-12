# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100130113502) do

  create_table "addresses", :force => true do |t|
    t.integer  "country_id"
    t.integer  "district_id"
    t.integer  "municipality_id"
    t.integer  "city_id"
    t.integer  "quarter_id"
    t.string   "street"
    t.string   "number"
    t.string   "entrance"
    t.integer  "floor"
    t.string   "apartment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.integer  "municipality_id"
    t.integer  "type"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "city_translations", :force => true do |t|
    t.integer  "city_id"
    t.string   "locale"
    t.text     "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "city_translations", ["city_id"], :name => "index_city_translations_on_city_id"

  create_table "countries", :force => true do |t|
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_translations", :force => true do |t|
    t.integer  "country_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "country_translations", ["country_id"], :name => "index_country_translations_on_country_id"

  create_table "district_translations", :force => true do |t|
    t.integer  "district_id"
    t.string   "locale"
    t.text     "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "district_translations", ["district_id"], :name => "index_district_translations_on_district_id"

  create_table "districts", :force => true do |t|
    t.integer  "country_id"
    t.boolean  "is_city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ekattes", :force => true do |t|
    t.integer "ekatte"
    t.string  "place_type"
    t.string  "name"
    t.string  "district"
    t.string  "municipality"
    t.integer "kind"
  end

  add_index "ekattes", ["ekatte", "district", "municipality"], :name => "index_ekattes_on_ekatte_and_district_and_municipality"

  create_table "municipalities", :force => true do |t|
    t.integer  "district_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "municipality_translations", :force => true do |t|
    t.integer  "municipality_id"
    t.string   "locale"
    t.text     "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "municipality_translations", ["municipality_id"], :name => "index_5e3a25223de7bbd82d27edc481fa389849010cae"

  create_table "oblasti", :force => true do |t|
    t.string  "oblast"
    t.integer "ekatte"
    t.string  "name"
  end

  add_index "oblasti", ["oblast", "ekatte"], :name => "index_oblasti_on_oblast_and_ekatte"

  create_table "obshtini", :force => true do |t|
    t.string  "obshtina"
    t.integer "ekatte"
    t.string  "name"
  end

  add_index "obshtini", ["obshtina", "ekatte"], :name => "index_obshtini_on_obshtina_and_ekatte"

  create_table "office_translations", :force => true do |t|
    t.integer  "office_id"
    t.string   "locale"
    t.text     "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "office_translations", ["office_id"], :name => "index_office_translations_on_office_id"

  create_table "offices", :force => true do |t|
    t.integer  "address_id"
    t.string   "mobile_phone"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quarter_translations", :force => true do |t|
    t.integer  "quarter_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quarter_translations", ["quarter_id"], :name => "index_quarter_translations_on_quarter_id"

  create_table "quarters", :force => true do |t|
    t.integer  "city_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_translations", :force => true do |t|
    t.integer  "role_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_translations", ["role_id"], :name => "index_role_translations_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ident"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                               :null => false
    t.string   "email",                               :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "password_salt",                       :null => false
    t.string   "persistence_token",                   :null => false
    t.string   "single_access_token",                 :null => false
    t.string   "perishable_token",                    :null => false
    t.integer  "login_count",          :default => 0, :null => false
    t.integer  "failed_login_count",   :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.text     "signature"
    t.text     "chat"
    t.string   "webpage"
    t.string   "company_webpage"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

end
